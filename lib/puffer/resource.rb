module Puffer

  ##############################################################
  #
  #  Resource is presenter layer for controllers.
  #
  ##############################################################

  class Resource

    include Routing
    include Scoping

    attr_reader :request, :params, :namespace, :action, :controller_name, :model_name, :controller, :model

    def initialize params, request = nil
      params = Marshal.load Marshal.dump(params)
      @action = params.delete :action
      @controller = "#{params.delete :controller}_controller".camelize.constantize
      @controller_name = controller.controller_name
      @namespace = controller.namespace
      @model_name = controller.model_name if controller.puffer?
      @model = controller.model if controller.puffer?
      @params = params
      @request = request
    end

    def plural?
      params[:plural]
    end

    def human
      model.model_name.human
    end

    def parent
      @parent ||= begin
        parent_ancestors = params[:ancestors].dup rescue []
        parent_name = parent_ancestors.pop
        if parent_name
          parent_params = ActiveSupport::HashWithIndifferentAccess.new({
            :controller => "#{namespace}/#{parent_name.to_s.pluralize}",
            :action => 'index',
            :plural => parent_name.plural?,
            :ancestors => parent_ancestors,
            :children => []
          })

          parent_ancestors.each do |ancestor|
            key = ancestor.to_s.singularize.foreign_key
            parent_params.merge! key => params[key] if params[key]
          end
          parent_params.merge! :id => params[parent_name.to_s.singularize.foreign_key]

          Resource.new parent_params, request
        else
          nil
        end
      end
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

    def children(custom_params = {})
      @children ||= params[:children].map do |child_name|
        child_params = ActiveSupport::HashWithIndifferentAccess.new(custom_params.deep_merge({
          :controller => "#{namespace}/#{child_name.to_s.pluralize}",
          :action => 'index',
          :plural => child_name.plural?,
          :ancestors => params[:ancestors].dup.push((plural? ? controller_name : controller_name.singularize).to_sym),
          :children => []
        }))

        params[:ancestors].each do |ancestor|
          key = ancestor.to_s.singularize.foreign_key
          child_params.merge! key => params[key] if params[key]
        end
        child_params.merge! controller_name.singularize.foreign_key => params[:id] if params[:id]

        Resource.new child_params, request
      end
    end

    def collection_scope
      parent ? parent.member.send(model_name.pluralize) : model
    end

    def collection
      collection_scope.includes(includes).where(searches(params[:search])).order(order).paginate :page => params[:page]
    end

    def member
      if parent
        if plural?
          parent.member.send(model_name.pluralize).find params[:id]
        else
          parent.member.send(model_name)
        end
      else
        model.find params[:id]
      end
    end

    def new_member
      if parent
        if plural?
          parent.member.send(model_name.pluralize).new attributes
        else
          parent.member.send("build_#{model_name}", attributes)
        end
      else
        model.new attributes
      end
    end

    def attributes
      params[model_name]
    end

    def method_missing method, *args, &block
      method = method.to_s
      if method.match(/path$/) && respond_to?(method.gsub(/path$/, 'url'))
        options = args.extract_options!
        return send method.gsub(/path$/, 'url'), *(args << options.merge(:routing_type => :path))
      end
      model.send method, *args, &block if model.respond_to? method
    end

  end
end
