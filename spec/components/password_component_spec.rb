require 'spec_helper'

describe PasswordComponent do

  include RSpec::Rails::RequestExampleGroup

  context 'form' do

    it 'should render form field' do
      pending
      @user = Fabricate :user
      get admin_users_path

      field = controller.form_fields[:password]
      component = ''
      controller.view_context.form_for @user, :url => admin_user_path(@user) do |form|
        component = Puffer::Component::Base.render_component(controller, field, :form, :form => form)
      end

      component.should have_selector('label[for=user_password]')
      component.should have_selector("input[type=password]")
    end

  end

  context 'index' do

    it 'should render field content' do
      pending
      @user = Fabricate :user
      get admin_users_path

      field = controller.index_fields[:password]
      Puffer::Component::Base.render_component(controller, field, :index, :record => @user).should == '*' * @user.password.mb_chars.length
    end

  end

end