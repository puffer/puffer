module Puffer
  module Inputs

    mattr_accessor :mappings
    self.mappings = {}

    def self.map_type *args
      to = args.extract_options![:to]
      raise ArgumentError, "You need to give :to as option to map_type" unless to
      args.each { |type| mappings[type] = to }
    end

    map_type :belongs_to, :has_one, :to => Puffer::Inputs::Association
    map_type :has_many, :has_and_belongs_to_many, :to => Puffer::Inputs::CollectionAssociation
    map_type :date, :time, :datetime, :timestamp, :to => Puffer::Inputs::DateTime

    def self.map_field field
      mappings[field.type] || (const_defined?(field.type.to_s.classify) ?
        "Puffer::Inputs::#{field.type.to_s.classify}".constantize : Puffer::Inputs::Base)
    end

  end
end
