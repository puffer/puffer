require 'spec_helper'

describe Puffer::Filters do

  describe 'controller filters class generation' do

    it 'should generate class with proper name' do
      Puffer::Filters.controller_filters(Admin::UsersController).should == Admin::UsersControllerFilters
    end

    it 'should return Puffer::Filters subclass' do
      Puffer::Filters.controller_filters(Admin::UsersController).superclass.should == Puffer::Filters
    end

    it 'should set proper attributes' do
      Puffer::Filters.controller_filters(Admin::PostsController).new.attributes.keys.should == %w(user.email status title body puffer_search puffer_order)
    end

  end

end