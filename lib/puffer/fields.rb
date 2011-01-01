module Puffer
  class Fields < Array

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
