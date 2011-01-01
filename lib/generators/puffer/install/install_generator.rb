class Puffer::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def generate_files
    directory 'puffer', 'public/puffer'
  end

  def generate_config
    copy_file 'puffer.rb', 'config/puffer.rb'
  end

end
