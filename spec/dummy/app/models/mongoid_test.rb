class MongoidTest
  include Mongoid::Document

  field :string_field, :type => String
  field :integer_field, :type => Integer, :default => 0
  field :array_field, :type => Array
end