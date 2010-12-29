module Puffer
  module Controller
    module Actions

      def self.included base
        base.class_eval do
          extend ClassMethods
        end
      end

      module ClassMethods

        def generate_association_actions field
          field.collection? ? generate_collection_association_actions(field) : generate_single_association_actions(field)
        end

        def generate_single_association_actions field
          define_method "associated_#{field}_choosing" do
            @record = model.find params[:id]
            @records = field.association.klass.scoped(:conditions => search_query(field.association_fields)).paginate(:page => params[:page], :include => includes(field.association_fields))
            @field = field
            render 'puffer/associated/one'
          end
        end

        def generate_collection_association_actions field
          define_method "associated_#{field}" do
            @record = model.find params[:id]
            @records = field.association.klass.scoped(:conditions => {:id => params[:ids]}).scoped(:conditions => search_query(field.association_fields)).paginate(:page => params[:page], :include => includes(field.association_fields))
            @field = field
            render 'puffer/associated/many'
          end

          define_method "associated_#{field}_choosing" do
            @record = model.find params[:id]
            @records = field.association.klass.scoped(:conditions => search_query(field.association_fields)).paginate(:page => params[:page], :include => includes(field.association_fields))
            @choosen = field.association.klass.scoped(:conditions => {:id => params[:ids]}).scoped(:conditions => search_query(field.association_fields)).paginate(:page => params[:page], :include => includes(field.association_fields))
            @field = field
            render 'puffer/associated/many'
          end
        end

        def generate_change_actions field
          define_method "toggle_#{field}" do
            @record = model.find params[:id]
            @field = field
            @record.toggle! field.name.to_sym
            render 'puffer/toggle'
          end
        end

      private

        def route_member_actions
          unless @route_member_actions
            @route_member_actions = {}
            actions.each do |action|
              @route_member_actions.merge!(action => :get)
            end
            [:form_fields, :update_fields, :create_fields].each do |fields|
              fields = send fields
              fields.each do |field|
                if field.association?
                  field.collection? ? @route_member_actions.merge!("associated_#{field}" => :get, "associated_#{field}_choosing" => :get) : @route_member_actions.merge!("associated_#{field}_choosing" => :get)
                end
              end if fields
            end
            index_fields.each do |field|
              @route_member_actions.merge!("toggle_#{field}" => :post) if field.toggable?
            end if index_fields
          end
          @route_member_actions
        end

      end

    end
  end
end
