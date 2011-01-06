class Puffer::ControllerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def generate_controller
    @modules = name.classify.split('::')
    @model_name = @modules.delete_at(-1)

    template('controller.rb', "app/controllers/#{controller_name.underscore}_controller.rb")
  end

private

  def controller_name
    [(swallow_nil{@modules.first} || 'Admin'), @model_name.pluralize].join('::')
  end

  def attributes
    @model_name.constantize.columns.map(&:name)
  end

end
