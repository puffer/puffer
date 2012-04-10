class MongoidOrm::Primal
  include Mongoid::Document

  field :string_field, :type => String
  field :symbol_field, :type => Symbol
  field :select_field, :type => String
  field :integer_field, :type => Integer
  field :float_field, :type => Float
  field :decimal_field, :type => BigDecimal
  field :datetime_field, :type => DateTime
  field :time_field, :type => Time
  field :date_field, :type => Date
  field :boolean_field, :type => Boolean
  field :array_field, :type => Array
  field :hash_field, :type => Hash
  field :set_field, :type => ::Set
  field :range_field, :type => Range
  field :localized_field, :localize => true
  field :time_zone

  has_one :has_one_nested, :validate => true, :class_name => 'MongoidOrm::HasOneReference'
  has_many :has_many_nesteds, :validate => true, :class_name => 'MongoidOrm::HasManyReference'

  has_one :has_one_reference, :validate => true, :class_name => 'MongoidOrm::HasOneReference'
  has_many :has_many_references, :validate => true, :class_name => 'MongoidOrm::HasManyReference'

  embeds_one :embeds_one_nested, :validate => true, :class_name => 'MongoidOrm::EmbedsOneReference'
  embeds_many :embeds_many_nesteds, :validate => true, :class_name => 'MongoidOrm::EmbedsManyReference'

  accepts_nested_attributes_for :has_one_nested, :has_many_nesteds, :allow_destroy => true

  def has_one_reference_id
    has_one_reference.try(:id)
  end

  def has_one_reference_id= value
    has_one_reference = reflect_on_association(:has_one_reference).klass.where(:_id => value).first
  end

  def array_field_before_type_cast
    array_field.join(', ') if array_field.present?
  end

  def array_field= value
    value = value.split(',').map(&:strip).map(&:presence).compact if value.is_a? String
    write_attribute :array_field, value
  end

  def set_field_before_type_cast
    set_field.to_a.join(', ') if set_field.present?
  end

  def set_field= value
    value = value.split(',').map(&:strip).map(&:presence).compact if value.is_a? String
    write_attribute :set_field, value
  end

  def range_field_before_type_cast
    range_field.to_s
  end

  def range_field= value
    value = Range.new(*value.split('..', 2).map(&:to_i)) rescue nil if value.is_a? String
    write_attribute :range_field, value
  end

end
