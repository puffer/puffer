module Puffer
  module Inputs

    mattr_accessor :mappings
    self.mappings = {}

    def self.map_type *args
      to = args.extract_options![:to]
      args.each { |type| mappings[type] = to }
    end

    map_type :belongs_to, :has_one, :to => Puffer::Inputs::Association
    map_type :has_many, :has_and_belongs_to_many, :to => Puffer::Inputs::CollectionAssociation
    map_type :date, :time, :datetime, :timestamp, :to => Puffer::Inputs::DateTime

    def self.map_field field
      mappings[field.type] || ("Puffer::Inputs::#{field.type.to_s.classify}".constantize rescue Puffer::Inputs::Base)
    end

  end
end
