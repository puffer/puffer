module Puffer
  class TreeBase < Puffer::Base
    unloadable

    helper :puffer_tree

    define_fieldset :tree, :fallbacks => :index

    def index
      return super if puffer_filters.any?
      @records = resource.collection_scope
      if session[:expanded].present?
        @records = @records.where(["depth in (0, 1) or parent_id in (#{session[:expanded].join(', ')})"]).arrange
      else
        @records = @records.with_depth([0, 1]).arrange
      end
      render 'tree'
    end

    member do
      get :inherit, :label => 'inherit'
      get :expand, :display => false
      get :collapse, :display => false
    end

    def inherit
      @parent = resource.member
      @record = @parent.children.new
      render 'new'
    end

    def expand
      @parent = resource.member
      session[:expanded] ||= []
      session[:expanded].push params[:id] if @parent
      session[:expanded].uniq!
      @records = resource.model.to_adapter.filter(@parent.self_and_descendants.where(:parent_id => [@parent.parent_id] + session[:expanded]), tree_fields).arrange
      render 'toggle'
    end

    def collapse
      @parent = resource.member
      session[:expanded] ||= []
      session[:expanded].delete params[:id]
      @records = resource.model.to_adapter.filter(resource.collection_scope.where(:id => [@parent.id]), tree_fields).arrange
      render 'toggle'
    end

  end
end
