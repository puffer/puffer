module Puffer

  mattr_accessor :stylesheets
  self.stylesheets = %w(reset puffer)

  mattr_accessor :javascripts
  self.javascripts = %w(right right-calendar right-autocompleter rails puffer)

  mattr_accessor :logo
  self.logo = 'Puffer'

  def self.setup
    yield self
  end

end

require 'will_paginate'
require 'cells'

require 'puffer/engine'
require 'puffer/extensions/activerecord'
require 'puffer/extensions/controller'
require 'puffer/extensions/core'
require 'puffer/extensions/mapper'
require 'puffer/extensions/form'
