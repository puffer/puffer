class Puffer::ControllerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  class_option :namespace, :type => :string, :default => 'Admin', :aliases => '-n',
    :desc => 'Generated controller namespace'
  class_option :controller_name, :type => :string, :aliases => '-c',
    :desc => 'Generated controller name'

  def generate_controller
    path =  File.join(%W{app controllers #{options.namespace.to_s.underscore.presence} #{controller_name.underscore}_controller.rb})
    template 'controller.rb', path
  end

  def generate_routes
    if options.namespace.present?
      route "namespace :#{options.namespace.to_s.underscore} do\n    resources :#{controller_name.underscore}\n  end"
    else
      route "resources :#{controller_name.underscore}"
    end
  end

private

  def model_name
    @model_name ||= name.camelize
  end

  def controller_name
    @controller_name ||= options.controller_name.present? ?
      options.controller_name.camelize.demodulize.pluralize :
      model_name.demodulize.pluralize
  end

  def attributes
    @attributes ||= model_name.constantize.to_adapter.column_names
  end

end
