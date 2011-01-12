module Puffer
  class PathSet < ::ActionView::PathSet

    def find(path, prefix = nil, partial = false, details = {}, key = nil)
      begin
        super(path, prefix, partial, details, key)
      rescue ::ActionView::MissingTemplate => e
        begin
          super(path, 'puffer', partial, details, key)
        rescue ::ActionView::MissingTemplate => ee
          raise e
        end
      end
    end

  end
end
