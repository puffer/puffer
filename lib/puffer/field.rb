module Puffer
  class Field

    attr_accessor :name, :options, :main_model

    def initialize(model, name, options = {})
      @main_model = model
      @name = name
      @options = options
    end

    def order
      @order ||= options[:order] || query_column
    end

    def label
      @label ||= options[:label] || @name.to_s.humanize
    end

    def [](key)
      @options[key]
    end

    def to_s
      @name.to_s
    end

    def own?
      model == main_model
    end

    def toggable?
      options[:toggable] = true if options[:toggable].nil?
      own? && type == :boolean && options[:toggable]
    end

    def association
      @association ||= main_model.reflect_on_association(to_s.split('.').first.to_sym)
    end

    def association?
      !!association
    end

    def collection?
      association? && [:has_many, :has_and_belongs_to_many].include?(association.macro)
    end

    def association_fields
      @association_fields ||= @options[:fields].map {|sym| self.class.new(association.klass, sym) }
    end

    def association_key
      association.primary_key_name
    end

    def record
      name.split('.')[0..-2].join('.')
    end

    def model
      unless @model
        try_model = to_s.split('.')[-2]
        @model = try_model.classify.constantize rescue nil if try_model
        @model ||= main_model
      end
      @model
    end

    def type
      @options[:type] = :association if association?
      @options[:type].to_sym || swallow_nil{column.type}
    end

    def column
      @column ||= model.columns.detect { |c| c.name == to_s.split('.').last}
    end

    def column?
      !!column
    end

    def query_column
      "#{model.to_s.tableize}.#{to_s.split('.').last}" if column
    end

  end
end
