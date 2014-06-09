require 'spec_helper'

if ENV['STRONG_PARAMETERS']
  describe Puffer::Base do
    controller do
      pufferize!

      setup do
        group :post
        model_name 'Post'
      end

      define_fieldset :form

      form do
        field :title
        field :body
        field :user, :type => :nested_attributes_one do
          field :email
        end
      end

      def send_action method_name, *args
        params[:puffer] = Puffer::Resource::Node.new(nil,
          :name => :anonymous, :controller => self.class, :singular => false
        )
        send method_name, *args
      end
    end

    it 'should pass to model only permitted params' do
      Post.should_receive(:new).with(
        'title' => 'test',
        'body' => 'test body',
        'user_attributes' => {'email' => 'test'}
      ).and_call_original

      post :create, :post => {
        :title => 'test',
        :body => 'test body',
        :published => true,
        :user_attributes => {:email => 'test', :is_admin => true}
      }
    end
  end
end
