module Puffer
  class GridBase < Puffer::Base

    define_fieldset :grid, :fallbacks => :index

    setup do
      per_page 60
    end

    #helper 'puffer/helpers/puffer_grid'
  end
end
