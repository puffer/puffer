module Puffer
  class FieldSet < Array

    attr_accessor :name

    def initialize name = nil
      @name = name
      super()
    end

    def field name, resource, options, &block
      push Puffer::Field.new(name, resource, self, options, &block)
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

    def [] key
      if key.is_a?(String) || key.is_a?(Symbol)
        detect {|f| f.to_s == key.to_s}
      else
        super
      end
    end

  end
end
