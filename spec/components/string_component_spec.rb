require 'spec_helper'

describe StringComponent do

  include RSpec::Rails::RequestExampleGroup

  context 'form' do

    it 'should render form field' do
      pending
      @category = Fabricate :category
      get admin_categories_path

      field = controller.form_fields[:title]
      component = ''
      controller.view_context.form_for @category, :url => admin_category_path(@category) do |form|
        component = Puffer::Component::Base.render_component(controller, field, :form, :form => form)
      end

      component.should have_selector('label[for=category_title]')
      component.should have_selector("input[type=text][value='#{@category.title}']")
    end

  end

end