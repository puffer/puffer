class <%= controller_name %>Controller < Puffer::Base

  setup do
    group :<%= @model_name.underscore.pluralize %>
  end

  index do
<% attributes.each do |attribute| -%>
    field :<%= attribute %>
<% end -%>
  end

  form do
<% attributes.each do |attribute| -%>
    field :<%= attribute %>
<% end -%>
  end

end
