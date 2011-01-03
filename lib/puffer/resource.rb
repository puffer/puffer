module Puffer

  ##############################################################
  #
  #  Resource is presenter layer for controllers.
  #
  ##############################################################

  class Resource

    include Routing
    include Scoping

    attr_reader :request, :params, :prefix, :action, :controller_name, :model_name, :controller, :model

    def initialize params, request = nil
      @action = params.delete :action
      @controller = "#{params[:controller]}_controller".classify.constantize
      controller_segments = params.delete(:controller).split('/')
      @prefix = controller_segments.first
      @controller_name = controller_segments.last
      @model_name = (controller.current_config.model || controller_name.singularize).to_s
      @model = model_name.classify.constantize
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
        parent_ancestors = params[:ancestors].dup
        parent_name = parent_ancestors.pop
        if parent_name
          parent_params = ActiveSupport::HashWithIndifferentAccess.new({
            :controller => "#{prefix}/#{parent_name.to_s.pluralize}",
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

          self.class.new parent_params, request
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

    def children(custom_params = {})
      @children ||= params[:children].map do |child_name|
        child_params = ActiveSupport::HashWithIndifferentAccess.new(custom_params.deep_merge({
          :controller => "#{prefix}/#{child_name.to_s.pluralize}",
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

        self.class.new child_params, request
      end
    end

    def collection
      scope = parent ? parent.member.send(model_name.pluralize) : model
      scope.includes(includes).joins(includes).order(order).paginate :page => params[:page]
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
      params[model_name] || {}
    end

    def template suggest = nil
      "puffer/#{suggest || action}"
    end

    def method_missing method, *args, &block
      method = method.to_s
      if method.match(/path$/)
        options = args.extract_options!
        return send method.gsub(/path$/, 'url'), *(args << options.merge(:routing_type => :path)) if defined? method.gsub(/path$/, 'url')
      end
      model.send method, *args, &block
    end

  end
end
