class Puffer::ControllerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)
  class_option :namespace, :type => :string, :default => 'Admin', :aliases => '-n', :description => 'Generated controller namespace'

  def generate_controller
    path =  File.join(%W{app controllers #{options.namespace.to_s.underscore.presence} #{controller_name.underscore}_controller.rb})
    template 'controller.rb', path
  end

private

  def model_name
    @model_name ||= name.camelize
  end

  def controller_name
    @controller_name ||= model_name.demodulize.pluralize
  end

  def attributes
    @attributes ||= model_name.constantize.to_adapter.column_names
  end

end
