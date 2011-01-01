module Puffer
  class Base < ApplicationController
    unloadable

    respond_to :html, :js

    include Puffer::Controller::Mutate
    include Puffer::Controller::Dsl
    include Puffer::Controller::Helpers

    def index
      @records = current_resource.collection
    end

    def show
      @record = current_resource.member
    end

    def new
      @record = current_resource.new_member
    end

    def edit
      @record = current_resource.member
    end

    def create
      @record = current_resource.new_member
      @record.save
      respond_with @record, :location => current_resource.path
    end

    def update
      @record = current_resource.member
      @record.update_attributes current_resource.attributes
      respond_with @record, :location => current_resource.path
    end

    def destroy
      @record = current_resource.member
      @record.destroy
      redirect_to current_resource.path
    end

  end
end
