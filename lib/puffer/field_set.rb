module Puffer
  class FieldSet < Array

    def field *args, &block
      push Puffer::Field.new(*args, &block)
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
