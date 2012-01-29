require 'spec_helper'

shared_examples "an adapter" do

  describe 'filtering' do

    def filter options = {}
      model.to_adapter.filter(model, controller.index_fields, options).all.to_a
    end


    def nth *indexes
      model.all.to_a.values_at *indexes
    end

    context 'without params' do

      before do
        5.times { Fabricate fabric }
      end

      it 'should return all records' do
        filter.should == model.all.to_a
      end

    end

    context 'search' do

      before do
        string_fields = %w(hello hello world hello world)
        select_fields = %w(hello world helloworld hello world)
        5.times { |i|
          Fabricate fabric, :string_field => string_fields[i], :select_field => select_fields[i]
        }
      end

      it 'should return all searched records' do
        filter(:search => 'hel').should =~ nth(0, 1, 2, 3)
      end

      it 'should return searched records without conditioned' do
        filter(:search => 'hel', :conditions => {'select_field' => 'hello'}).should =~ nth(0, 3)
      end

      it 'should return searched records without conditioned' do
        filter(:search => 'hel', :conditions => {'select_field' => 'world'}).should =~ nth(1)
      end

    end

    context 'select' do

      before do
        select_fields = %w(hello world hello hello world)
        boolean_fields = %w(true false false true false)
        5.times { |i|
          Fabricate fabric, :select_field => select_fields[i], :boolean_field => boolean_fields[i]
        }
      end

      it 'should return all conditioned records' do
        filter(:conditions => {'select_field' => 'hello'}).should =~ nth(0, 2, 3)
      end

      it 'should return all conditioned records' do
        filter(:conditions => {'boolean_field' => false}).should =~ nth(1, 2, 4)
      end

      it 'should stack conditions with end' do
        filter(:conditions => {'select_field' => 'hello', 'boolean_field' => true}).should =~ nth(0, 3)
      end

    end

    context 'order' do

      before do
        integer_fields = %w(2, 3, 5, 4, 1)
        5.times { |i|
          Fabricate fabric, :integer_field => integer_fields[i]
        }
      end

      it 'should order records asc' do
        filter(:order => 'integer_field').should =~ nth(4, 0, 1, 3, 2)
      end

      it 'should order records asc' do
        filter(:order => ['integer_field', :asc]).should =~ nth(4, 0, 1, 3, 2)
      end

      it 'should order records desc' do
        filter(:order => ['integer_field', :desc]).should =~ nth(2, 3, 1, 0, 4)
      end

    end

    context 'diapazones' do
      Timecop.freeze Time.now do
        before do
          5.times { |i|
            Fabricate fabric, :datetime_field => Time.now + i.hours
          }
        end

        it 'should return from till' do
          filter(:conditions => {'datetime_field' => Puffer::Filters::Diapason.new(Time.now + 0.9.hour, Time.now + 3.1.hours)}).should =~ nth(1, 2, 3)
        end

        it 'should return from' do
          filter(:conditions => {'datetime_field' => Puffer::Filters::Diapason.new(Time.now + 0.9.hour)}).should =~ nth(1, 2, 3, 4)
        end

        it 'should return till' do
          filter(:conditions => {'datetime_field' => Puffer::Filters::Diapason.new(nil, Time.now + 3.1.hours)}).should =~ nth(0, 1, 2, 3)
        end
      end
    end

  end

end