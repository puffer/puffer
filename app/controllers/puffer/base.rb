module Puffer
  class Base < ApplicationController
    unloadable
    pufferize!

    before_filter :require_puffer_user

    define_fieldset :index, :form
    define_fieldset :show, :fallbacks => :index
    define_fieldset :create, :update, :fallbacks => :form

    respond_to :html, :js

    def index
      @records = resource.collection.page(params[:page])
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
      respond_with @record, :location => puffer_saving_location
    end

    def update
      @record = resource.member
      @record.update_attributes resource.attributes
      respond_with @record, :location => puffer_saving_location
    end

    def destroy
      @record = resource.member
      @record.destroy
      redirect_to (request.referrer || resource.collection_path)
    end

    def event
      render :text => fields(params[:fieldset])[params[:field]].render(self, params[:event])
    end

  private

    def puffer_saving_location
      params[:commit] == t('puffer.save') ? resource.edit_path(record) : resource.collection_path
    end

  end
end
