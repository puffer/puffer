require 'spec_helper'

describe BaseComponent do

  include RSpec::Rails::RequestExampleGroup

  context 'index' do

    it 'should render field content' do
      @category = Fabricate :category
      get admin_categories_path

      field = controller.index_fields[:title]
      Puffer::Component::Base.render_component(controller, field, :index, :record => @category).should == @category.title
    end

  end

end