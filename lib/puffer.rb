require 'kaminari'
require 'orm_adapter'

require 'puffer/extensions/engine'
require 'puffer/extensions/controller'
# if Rails.version < '3.2'
#   require 'puffer/extensions/mapper31'
# else
#   require 'puffer/extensions/mapper32'
# end
require 'puffer/extensions/directive_processor'
require 'puffer/engine'

module Puffer
  autoload :Base, 'puffer/controller/base'
end
