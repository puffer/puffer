module Puffer

  mattr_accessor :stylesheets
  self.stylesheets = %w(/puffer/stylesheets/reset /puffer/stylesheets/puffer)

  mattr_accessor :javascripts
  self.javascripts = %w(/puffer/javascripts/right /puffer/javascripts/right-calendar /puffer/javascripts/right-autocompleter /puffer/javascripts/rails /puffer/javascripts/puffer)

  mattr_accessor :logo
  self.logo = 'Puffer'

  def self.setup
    yield self
  end

end

require 'puffer/engine'
require 'puffer/extensions/activerecord'
require 'puffer/extensions/controller'
require 'puffer/extensions/core'
require 'puffer/extensions/mapper'
require 'puffer/extensions/form'
