module Puffer

  def self.customs
    Puffer::Customs
  end

end

require 'puffer/engine'
require 'puffer/extensions/activerecord'
require 'puffer/extensions/controller'
require 'puffer/extensions/core'
require 'puffer/extensions/mapper'
require 'puffer/extensions/form'
