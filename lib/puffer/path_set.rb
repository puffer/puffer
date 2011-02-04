module Puffer
  class PathSet < ::ActionView::PathSet

    class_attribute :_fallbacks
    self._fallbacks = []

    def find(path, prefix = nil, partial = false, details = {}, key = nil)
      prefixes = [prefix].concat _fallbacks
      paths = prefixes.map {|prefix| "#{prefix}/#{path}"}.join(', ')

      begin
        template = begin
          super(path, prefixes.shift.to_s, partial, details, key)
        rescue ::ActionView::MissingTemplate => e
          nil
        end
      end until prefixes.empty? || template

      raise ::ActionView::MissingTemplate.new(self, paths, details, partial) unless template
      template
    end

  end
end
