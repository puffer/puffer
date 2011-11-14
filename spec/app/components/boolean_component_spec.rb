require 'spec_helper'

describe BooleanComponent do

  include RSpec::Rails::RequestExampleGroup

  context 'index' do
    it 'should render checkbox' do
      pending
      @category = Fabricate :category
      get admin_categories_path

      field = controller.index_fields[:hidden]
      component = Puffer::Component::Base.render_component(controller, field, :index, :record => @category)

      p component
    end
  end

  context 'form' do
    it 'should render form field' do
      pending
      @category = Fabricate :category
      get admin_categories_path

      field = controller.form_fields[:hidden]
      component = ''
      controller.view_context.form_for @category, :url => admin_category_path(@category) do |form|
        component = Puffer::Component::Base.render_component(controller, field, :form, :form => form)
      end

      component.should have_selector("input[type=hidden][value='0']")
      component.should have_selector("input[type=checkbox][value='1']")
      component.should have_selector('label[for=category_hidden]')
    end
  end

end