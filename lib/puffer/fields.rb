module Puffer
  class Fields < Array

    class_attribute :offers
    self.offers = []

    def self.offer_type &block
      offers.push block if block_given?
    end

    def self.offered_type field
      swallow_nil{ offers.detect { |offer| offer.call(field) }.call(field) }
    end

    offer_type do |field|
      :select if field.options.key?(:select)
    end
    offer_type do |field|
      :password if field.name =~ /password/
    end
    offer_type do |field|
      field.model.reflect_on_association(name.to_sym).macro if field.model.reflect_on_association name.to_sym
    end

    def field *args
      push Field.new(*args)
    end

    def searchable
      @searchable ||= reject { |f| ![:text, :string, :integer, :decimal, :float].include? f.type }
    end

    def boolean
      @boolean ||= reject { |f| f.type != :boolean }
    end

  end
end
