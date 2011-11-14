require 'spec_helper'

describe Puffer::Filters do

  describe 'controller filters class generation' do

    it 'should set proper attributes' do
      Puffer::Filters.new(Admin::PostsController.filter_fields).attributes.keys.should == %w(user.email status title body puffer_search puffer_order)
    end

    it 'should set proper query' do
      Puffer::Filters.new(Admin::PostsController.filter_fields).query.keys.should == []
    end

  end

end