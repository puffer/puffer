require 'spec_helper'
require 'lib/orm_adapter/base_shared'

describe "ActiveRecordOrm" do

  describe 'columns_hash' do
    it 'should be proper' do
      ActiveRecordOrm::Primal.to_adapter.columns_hash.should == {
        "id" => {:type => :integer},
        "string_field" => {:type => :string},
        "text_field" => {:type => :text},
        "select_field" => {:type => :string},
        "integer_field" => {:type => :integer},
        "float_field" => {:type => :float},
        "decimal_field" => {:type => :decimal},
        "datetime_field" => {:type => :datetime},
        "timestamp_field" => {:type => :datetime},
        "time_field" => {:type => :time},
        "date_field" => {:type => :date},
        "boolean_field" => {:type => :boolean}
      }
    end
  end

  describe 'filter' do
    it_should_behave_like "an adapter" do
      let(:model) {ActiveRecordOrm::Primal}
      let(:fabric) {:active_record_orm_primal}
      let(:controller) {Orms::ActiveRecordOrmPrimalsController}
    end
  end

end