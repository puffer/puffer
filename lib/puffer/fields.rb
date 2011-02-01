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
      swallow_nil{ field.reflection.macro }
    end

    def field *args
      push Field.new(*args)
      last
    end

    def searchable
      @searchable ||= map { |f| f if f.column && [:text, :string, :integer, :decimal, :float].include?(f.column.type) }.compact
    end

    def searches query
      searchable.map { |f| "#{f.query_column} like '%#{query}%'" if f.query_column.present? }.compact.join(' or ') if query
    end

    def boolean
      @boolean ||= reject { |f| f.type != :boolean }
    end

    def includes
      @includes ||= map {|f| f.path unless f.native?}.compact.to_includes
    end

  end
end
