class MongoidTest
  include Mongoid::Document

  field :string_field, :type => String
  field :integer_field, :type => Integer, :default => 0
  field :array_field, :type => Array

  def array_field= value
    value = value.split(',').map(&:strip).map(&:presence) if value.is_a? String
    write_attribute :array_field, value
  end

end