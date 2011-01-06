module Puffer
  class Base < ApplicationController
    unloadable

    include Puffer::Controller::Mutate
    include Puffer::Controller::Helpers
    include Puffer::Controller::Dsl
    include Puffer::Controller::Config

    respond_to :html, :js

    def index
      @records = resource.collection
    end

    def show
      @record = resource.member
    end

    def new
      @record = resource.new_member
    end

    def edit
      @record = resource.member
    end

    def create
      @record = resource.new_member
      @record.save
      respond_with @record, :location => resource.path
    end

    def update
      @record = resource.member
      @record.update_attributes resource.attributes
      respond_with @record, :location => resource.path
    end

    def destroy
      @record = resource.member
      @record.destroy
      redirect_to resource.path
    end

  end
end
