module Puffer
  class GridBase < Puffer::Base
    unloadable

    setup do
      per_page 60
    end

    #helper 'puffer/helpers/puffer_grid'
  end
end
