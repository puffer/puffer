module Puffer
  module Controller
    module Fieldsets
      class Register

        def inherit
          inherited = dup
          inherited.send :ancestor=, self
          inherited.send :fieldsets=, Hash[fieldset_names.map { |name| [name] }]
          inherited.send :fallbacks=, Marshal.load(Marshal.dump(fallbacks))
          inherited
        end

        def declare name, options = {}
          name = name.to_sym
          fieldsets[name] = nil unless declared?(name)
          fallbacks[name] = Array.wrap(options[:fallback] || options[:fallbacks]).map(&:to_sym).unshift(name).uniq
        end

        def declared? name
          fieldsets.key?(name)
        end

        def fieldset_names
          fieldsets.keys.map(&:to_sym)
        end

        def [] name
          fallback(name)
        end

        def []= name, value
          fieldsets[name] = value if declared?(name)
        end

        def method_missing method, *args, &block
          name = method.to_s.gsub(/\=\Z/, '')
          if declared?(name)
            if name != method.to_s
              self[name] = args.first
            else
              self[name]
            end
          else
            super
          end
        end

        def respond_to_missing? method, _
          declared?(method.to_s.gsub(/\=\Z/, '')) || super
        end

      private

        attr_accessor :fieldsets, :fallbacks, :ancestor

        [:fieldsets, :fallbacks].each do |method|
          define_method method do
            value = instance_variable_get(:"@#{method}")
            case value
            when HashWithIndifferentAccess
              value
            when Hash
              instance_variable_set(:"@#{method}", value.with_indifferent_access)
            else
              instance_variable_set(:"@#{method}", {}.with_indifferent_access)
            end
          end
        end

        def fallback name
          fieldsets.values_at(*fallbacks[name]).compact.first ||
            ancestor.try(:fallback, name) if declared?(name)
        end

      end
    end
  end
end
