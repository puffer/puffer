require 'spec_helper'

describe TextComponent do

  include RSpec::Rails::RequestExampleGroup

  context 'form' do

    it 'should render form field' do
      @post = Fabricate :post
      get admin_posts_path

      field = controller.form_fields[:body]
      component = ''
      controller.view_context.form_for @post, :url => admin_post_path(@post) do |form|
        component = Puffer::Component::Base.render_component(controller, field, :form, :form => form)
      end

      component.should have_selector('label[for=post_body]')
      component.should have_selector('textarea', :content => @post.body)
    end

  end

end