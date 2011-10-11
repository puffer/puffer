require 'spec_helper'
require 'lib/orm_adapter/base_shared'

describe "MongoidOrm" do

  describe 'columns_hash' do
    it 'should be proper' do
      MongoidOrm::Primal.to_adapter.columns_hash.should == {
        "_type" => {:type => :string},
        "_id" => {:type => :"bson/object_id"},
        "string_field" => {:type => :string},
        "symbol_field" => {:type => :symbol},
        "select_field" => {:type => :string},
        "integer_field" => {:type => :integer},
        "float_field" => {:type => :float},
        "decimal_field" => {:type => :big_decimal},
        "datetime_field" => {:type => :date_time},
        "time_field" => {:type => :time},
        "date_field" => {:type => :date},
        "boolean_field" => {:type => :boolean},
        "array_field" => {:type => :array},
        "hash_field" => {:type => :hash},
        "set_field" => {:type => :set},
        "range_field" => {:type => :range}
      }
    end
  end

  describe 'filter' do
    it_should_behave_like "an adapter" do
      def filter options = {}
        model.to_adapter.filter(model, controller.index_fields, options).order([:_id, :asc]).all.to_a
      end


      def nth *indexes
        model.where.order([:_id, :asc]).all.to_a.values_at *indexes
      end

      let(:model) {MongoidOrm::Primal}
      let(:fabric) {:mongoid_orm_primal}
      let(:controller) {Orms::MongoidOrmPrimalsController}
    end
  end

end