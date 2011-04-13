module Puffer
  module Customs

    # Custom field types

    mattr_accessor :types
    self.types = []

    def self.map_type &block
      types.unshift block if block_given?
    end

    def self.type_for field
      swallow_nil{ types.detect { |offer| offer.call(field) }.call(field) }
    end

    map_type { |field| :select if field.options.key?(:select) }
    map_type { |field| :password if field.name =~ /password/ }
    map_type { |field| swallow_nil{ field.reflection.macro } }


    # Custom inputs

    mattr_accessor :inputs
    self.inputs = {}

    def self.map_input *args
      to = args.extract_options![:to]
      args.each { |type| inputs[type] = to }
    end

    def self.input_for field
      inputs[field.type] || ("Puffer::Inputs::#{field.type.to_s.camelize}".constantize rescue Puffer::Inputs::Base)
    end

    map_input :belongs_to, :has_one, :to => Puffer::Inputs::Association
    map_input :has_many, :has_and_belongs_to_many, :to => Puffer::Inputs::CollectionAssociation
    map_input :date, :time, :datetime, :timestamp, :to => Puffer::Inputs::DateTime


    # Customs renderers

    mattr_accessor :renderers
    self.renderers = {}

    def self.map_renderer *args
      to = args.extract_options![:to]
      args.each { |type| renderers[type] = to }
    end


    # Customs filters

    mattr_accessor :filters
    self.filters = {}

    def self.map_filter *args
      to = args.extract_options![:to]
      args.each { |type| filters[type] = to }
    end

  end
end

