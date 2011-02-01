module Puffer
  module Controller
    module Generated

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
            @field = field
            @record = resource.member if params[:id]
            @records = field.reflection.klass.includes(field.association_fields.includes).joins(field.association_fields.includes).where(field.association_fields.searches(params[:search])).limit(100).all
            render 'puffer/associated/one'
          end

          collection do
            get "associated_#{field}_choosing"
          end
        end

        def generate_collection_association_actions field
          define_method "associated_#{field}" do
            @record = resource.member
            @records = field.association.klass.scoped(:conditions => {:id => params[:ids]}).scoped(:conditions => search_query(field.association_fields)).paginate(:page => params[:page], :include => includes(field.association_fields))
            @field = field
            render 'puffer/associated/many'
          end

          define_method "associated_#{field}_choosing" do
            @record = resource.member
            @records = field.association.klass.scoped(:conditions => search_query(field.association_fields)).paginate(:page => params[:page], :include => includes(field.association_fields))
            @choosen = field.association.klass.scoped(:conditions => {:id => params[:ids]}).scoped(:conditions => search_query(field.association_fields)).paginate(:page => params[:page], :include => includes(field.association_fields))
            @field = field
            render 'puffer/associated/many'
          end

          collection do
            get "associated_#{field}"
            get "associated_#{field}_choosing"
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

      end

    end
  end
end
