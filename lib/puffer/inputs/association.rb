# coding: utf-8
module Puffer
  module Inputs
    class Association < Puffer::Inputs::Base

      def input
        <<-INPUT
          <div class="association">
            #{text_field_tag field, value, field.input_options.merge(
                :autocomplete => :off,
                :disabled => (true if builder.object.send(field.name)),
                'data-autocompleter' => "{url: '#{resource.collection_path(:action => "associated_#{field}_choosing")}', onDone: association_done}"
              )}
            <div class="association_clear">×</div>
            #{builder.hidden_field field.reflection.foreign_key}
          </div>
        INPUT
      end

      def value
        value = [
          swallow_nil{builder.object.send(field.name)[field.reflection.primary_key_column.name.to_sym]},
          swallow_nil{builder.object.send(field.name).to_title}
        ].compact.join(' - ')
      end

      def label
        label_tag field
      end

      def error
        builder.object.errors[field.reflection.foreign_key.to_sym].first ||
          builder.object.errors[field.name.to_sym].first.presence
      end

    end
  end
end
