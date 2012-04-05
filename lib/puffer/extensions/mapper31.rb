module Puffer
  module Extensions
    # Extends rails mapper to provide resources nesting tree structure with
    # request params. Route defaults contains <tt>:puffer</tt> key with node
    # index in resources tree nodes array. See <tt>Puffer::Resource::Tree</tt>
    #
    # Resource tree depends on routes resources nesting.
    #
    # ex:
    #
    #   namespace :admin do
    #     resources :users do
    #       resource :profile
    #       resources :articles
    #     end
    #     resources :orders
    #   end
    #
    # will produce:
    #
    #   [
    #     {:scope => 'admin', :current => :users, :children => [:profile, :articles], :ancestors => []},
    #     {:scope => 'admin', :current => :profile, :children => [], :ancestors => [:users]},
    #     {:scope => 'admin', :current => :articles, :children => [], :ancestors => [:users]},
    #     {:scope => 'admin', :current => :orders, :children => [], :ancestors => []},
    #   ]
    #
    # a complete tree structure with nodes array to acces with node index
    # (<tt>Puffer::Resource::Tree#to_struct</tt>).
    #
    # Also this mapper extension adds come aaditional routes for every pufer
    # controller and namespace.
    module Mapper
      extend ActiveSupport::Concern

      included do
        alias_method_chain :namespace, :puffer
        alias_method_chain :resource_scope, :puffer
      end

      module InstanceMethods

        def namespace_with_puffer path, options = {}
          namespace_without_puffer path, options do
            yield

            if ::Rails.application.routes.resources_tree.any? {|node| node.scope == @scope[:module].to_sym}
              old, @scope[:module] = @scope[:module], 'admin'
              root :to => "dashboard##{old}"
              @scope[:module] = old
            end
          end
        end

        def resource_scope_with_puffer resource, &block
          controller = "#{[@scope[:module], resource.controller].compact.join("/")}_controller".camelize.constantize rescue nil
          if controller && controller.puffer?
            singular = resource.is_a? ActionDispatch::Routing::Mapper::Resources::SingletonResource
            name = (singular ? resource.singular : resource.plural).to_sym

            resource_node = ::Rails.application.routes.resources_tree.append_node swallow_nil{@scope[:defaults][:puffer]},
              :name => name, :scope => @scope[:module].to_sym, :controller => controller, :singular => singular

            defaults :puffer => resource_node do
              resource_scope_without_puffer resource do
                block.call if block

                member do
                  controller._members.each do |action|
                    send *action.route
                  end
                end

                collection do
                  controller._collections.each do |action|
                    send *action.route
                  end
                  get '/event/:fieldset/:field/:event(/:identifer)', :action => :event, :as => :event
                end
              end
            end
          else
            resource_scope_without_puffer resource, &block
          end
        end

      end
    end

    module RouteSet
      extend ActiveSupport::Concern

      included do
        alias_method_chain :clear!, :puffer
        attr_writer :resources_tree

        def resources_tree
          @resources_tree ||= Puffer::Resource::Tree.new
        end
      end

      module InstanceMethods

        def clear_with_puffer!
          @resources_tree = nil
          clear_without_puffer!
        end

      end
    end

  end
end

ActionDispatch::Routing::RouteSet.send :include, Puffer::Extensions::RouteSet
ActionDispatch::Routing::Mapper.send :include, Puffer::Extensions::Mapper
