require 'spec_helper'

describe DateTimeComponent do

  include RSpec::Rails::RequestExampleGroup

  context 'form' do

    it 'should render form field' do
      @user = Fabricate :user_with_profile
      get admin_user_profile_path(@user)

      field = controller.form_fields[:birth_date]
      field.options[:type] = :date_time
      component = ''
      controller.view_context.form_for @user.profile, :url => admin_user_profile_path(@user) do |form|
        component = Puffer::Component::Base.render_component(controller, field, :form, :form => form)
      end

      component.should have_selector('label[for=profile_birth_date]')
      component.should have_selector('input[data-calendar]')
    end

  end

end