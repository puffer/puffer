require 'kaminari'

require 'orm_adapter'
require 'puffer/orm_adapter/base'
require 'puffer/orm_adapter/active_record' if defined?(ActiveRecord::Base::OrmAdapter)
require 'puffer/orm_adapter/mongoid' if defined?(Mongoid::Document::OrmAdapter)
# require 'puffer/orm_adapter/data_mapper' if defined?(DataMapper::Resource::OrmAdapter)
# require 'puffer/orm_adapter/mongo_mapper' if defined?(MongoMapper::Document::OrmAdapter)

require 'puffer/extensions/engine'
require 'puffer/extensions/controller'
require 'puffer/extensions/core'
if Rails.version < '3.2'
  require 'puffer/extensions/mapper31'
else
  require 'puffer/extensions/mapper32'
end
require 'puffer/extensions/directive_processor'
require 'puffer/engine'

module Puffer

  TRUE_VALUES = [true, 1, '1', 't', 'T', 'true', 'TRUE'].to_set
  FALSE_VALUES = [false, 0, '0', 'f', 'F', 'false', 'FALSE'].to_set

  class PufferError < StandardError
  end

  class ComponentMissing < PufferError
  end

  autoload :Base, 'puffer/backends/controllers/base'
  autoload :TreeBase, 'puffer/backends/controllers/tree_base'
  autoload :GridBase, 'puffer/backends/controllers/grid_base'
  autoload :DashboardBase, 'puffer/backends/controllers/dashboard_base'
  autoload :PufferUsersBase, 'puffer/backends/controllers/puffer_users_base'

  module Sessions
    autoload :Base, 'puffer/backends/controllers/sessions/base'
    autoload :Simple, 'puffer/backends/controllers/sessions/simple'
    autoload :Clearance, 'puffer/backends/controllers/sessions/clearance'
  end

  module User
    autoload :Base, 'puffer/backends/models/user/base'
    autoload :ActiveRecord, 'puffer/backends/models/user/active_record'
    autoload :Mongoid, 'puffer/backends/models/user/mongoid'
  end

  module Controller
    autoload :Action, 'puffer/controller/actions'
    autoload :MemberAction, 'puffer/controller/actions'
    autoload :CollectionAction, 'puffer/controller/actions'
  end

  # Puffer has two types of mappings. If maps <tt>field.type</tt> to component
  # class and also maps field attributes to <tt>field.type</tt>
  mattr_accessor :_component_mappings
  self._component_mappings = {}

  # Maps <tt>field.type</tt> to component class
  #
  # ex:
  #
  #   Puffer.map_component :ckeditor, :rich, :text, :to => CkeditorComponent
  #
  # this declaration maps even text fields to use <tt>CkeditorComponent</tt> for
  # rendering
  def self.map_component *args
    to = args.extract_options![:to]
    args.each { |type| _component_mappings[type.to_sym] = to }
  end

  def self.component_for field
    type = field
    type = field.type if field.respond_to? :type
    (_component_mappings[type.to_sym] || "#{type}_component").to_s.camelize.constantize
  rescue NameError
    raise ComponentMissing, "Missing `#{type}` component for `#{field}` field. Please use Puffer.map_component binding or specify field type manually"
  end

  map_component :date, :time, :datetime, :date_time, :timestamp, :to => :DateTimeComponent
  map_component :integer, :float, :decimal, :big_decimal, :to => :StringComponent
  map_component :"mongoid/fields/serializable/object", :"bson/object_id", :symbol, :array, :hash, :set, :range, :to => :StringComponent




  mattr_accessor :_field_type_customs
  self._field_type_customs = []


  # Appends or prepends custom type.
  #
  # ex:
  #
  #   Puffer.append_custom_field_type :paperclip do |field|
  #     field.model.respond_to?(:attachment_definitions)
  #       && field.model.attachment_definitions.key?(:field.field_name.to_sym)
  #   end
  def self.prepend_custom_field_type custom_type, &block
    _field_type_customs.shift [custom_type, block]
  end

  def self.append_custom_field_type custom_type, &block
    _field_type_customs.push [custom_type, block]
  end

  def self.field_type_for field
    custom_type = swallow_nil{_field_type_customs.detect {|(type, block)| block.call(field) }.first}
    case custom_type
    when Proc then
      custom_type.call(field)
    else
      custom_type
    end
  end

  append_custom_field_type :nested_attributes_one do |field|
    field.reflection && [:references_one, :has_one].include?(field.reflection.macro) && !field.reflection.through? && field.model.instance_methods.include?(:"#{field}_attributes=")
  end
  append_custom_field_type :nested_attributes_one do |field|
    field.reflection && field.reflection.macro == :embeds_one
  end

  append_custom_field_type :nested_attributes_many do |field|
    field.reflection && [:references_many, :has_many].include?(field.reflection.macro) && !field.reflection.through? && field.model.instance_methods.include?(:"#{field}_attributes=")
  end
  append_custom_field_type :nested_attributes_many do |field|
    field.reflection && field.reflection.macro == :embeds_many
  end

  append_custom_field_type :references_one do |field|
    field.reflection && [:has_one, :belongs_to, :references_one, :referenced_in, :embedded_in].include?(field.reflection.macro)
  end
  append_custom_field_type :references_many do |field|
    field.reflection && [:has_many, :references_many, :has_and_belongs_to_many, :references_and_referenced_in_many].include?(field.reflection.macro)
  end

  append_custom_field_type :select do |field|
    field.options.key? :select
  end
  append_custom_field_type :password do |field|
    field.name =~ /password/
  end
  append_custom_field_type :render do |field|
    field.options.key? :render
  end

  append_custom_field_type :carrierwave do |field|
    field.model.respond_to?(:uploaders) && field.model.uploaders.key?(field.name.to_sym)
  end

end
