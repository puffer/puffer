require 'spec_helper'

describe SelectComponent do

  include RSpec::Rails::RequestExampleGroup

  context 'form' do

    it 'should render form field' do
      @post = Fabricate :post
      get admin_posts_path

      field = controller.form_fields[:status]
      field.options[:type] = :select
      component = ''
      controller.view_context.form_for @post, :url => admin_post_path(@post) do |form|
        component = Puffer::Component::Base.render_component(controller, field, :form, :form => form)
      end

      component.should have_selector('label[for=post_status]')
      component.should have_selector('select') do |select|
        Post.statuses.each do |status|
          select.should have_selector("option[value='#{status}']", :content => status)
        end
      end
    end

  end

end