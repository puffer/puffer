module Puffer

  ##############################################################
  #
  #  Resource is presenter layer for controllers.
  #
  ##############################################################

  class Resource

    include Routing

    attr_reader :resource_node, :scope, :params, :controller_instance
    delegate :controller, :name, :plural?, :singular, :plural, :url_segment, :to => :resource_node, :allow_nil => true
    delegate :model, :to => :controller, :allow_nil => true
    delegate :env, :request, :to => :controller_instance, :allow_nil => true

    def initialize params, controller_instance = nil
      params = ActiveSupport::HashWithIndifferentAccess.new.deep_merge params

      @resource_node = params[:puffer]
      @scope = swallow_nil{@resource_node.scope} || params[:puffer_scope]
      @params = params
      @controller_instance = controller_instance
    end

    def human
      model.model_name.human
    end

    def ancestors
      @ancestors ||= begin
        ancestors = []
        resource = self
        while resource = resource.parent do
          ancestors.unshift resource
        end
        ancestors
      end
    end

    def root
      @root ||= (ancestors.first || self)
    end

    def parent
      @parent ||= begin
        if resource_node.parent
          parent_params = ActiveSupport::HashWithIndifferentAccess.new({:puffer => resource_node.parent})

          resource_node.ancestors[0..-2].each do |ancestor|
            key = ancestor.to_s.singularize.foreign_key
            parent_params[key] = params[key] if params[key]
          end

          key = resource_node.parent.to_s.singularize.foreign_key
          parent_params[:id] = params[key] if params[key]

          self.class.new parent_params, controller_instance
        end
      end
    end

    def children
      @children ||= resource_node.children.map do |child_node|
        child_params = ActiveSupport::HashWithIndifferentAccess.new({:puffer => child_node})

        resource_node.ancestors.each do |ancestor|
          key = ancestor.to_s.singularize.foreign_key
          child_params[key] = params[key] if params[key]
        end

        key = resource_node.to_s.singularize.foreign_key
        child_params[key] = params[:id] if params[:id]

        self.class.new child_params, controller_instance
      end
    end

    def children_hash
      @children_hash ||= children.inject(ActiveSupport::HashWithIndifferentAccess.new) do |result, child|
        result[child.name] = child
        result
      end
    end

    def member_id
      params[:id]
    end

    def collection_scope
      parent ? parent.member.send(name) : model
    end

    def collection
      scope = collection_scope
      scope = scope.send controller.configuration.scope if controller.configuration.scope
      model.to_adapter.filter scope, controller.filter_fields,
        :conditions => controller_instance.puffer_filters.conditions,
        :search => controller_instance.puffer_filters.search,
        :order => controller_instance.puffer_filters.order
    end

    def member
      if parent
        if plural?
          parent.member.send(name).find member_id if member_id
        else
          parent.member.send(name)
        end
      else
        model.find member_id if member_id
      end
    end

    def new_member
      if parent
        if plural?
          parent.member.send(name).new attributes
        else
          parent.member.send("build_#{name}", attributes)
        end
      else
        model.new attributes
      end
    end

    def attributes
      params[name.to_s.singularize]
    end

    def method_missing method, *args, &block
      model.send method, *args, &block if model.respond_to? method
    end

  end
end
