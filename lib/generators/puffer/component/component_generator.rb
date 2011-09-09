class Puffer::ComponentGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def generate_component
    @name = name.underscore

    template 'component.rb', "app/components/#{@name}_component.rb"
    template 'component_spec.rb', "spec/app/components/#{@name}_component_spec.rb"
  end

  def generate_views
    @name = name.underscore

    create_file "app/components/#{@name}/index.html.erb", "# I'm index"
    create_file "app/components/#{@name}/form.html.erb", "# I'm form"
    create_file "app/components/#{@name}/filter.html.erb", "# I'm filter"
  end

end
