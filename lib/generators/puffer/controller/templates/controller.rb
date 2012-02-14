class <% if options.namespace? %><%= options.namespace.camelize %>::<% end %><%= controller_name %>Controller < Puffer::Base

  setup do
    group :<%= model_name.split('::').first.underscore %>
  end

  index do
<% attributes.each do |attribute| -%>
<% if %w(_id id _type type created_at updated_at).include?(attribute.to_s) -%>
    # field :<%= attribute %>
<% else -%>
    field :<%= attribute %>
<% end -%>
<% end -%>
  end

  form do
<% attributes.each do |attribute| -%>
<% if %w(_id id _type type created_at updated_at).include?(attribute.to_s) -%>
    # field :<%= attribute %>
<% else -%>
    field :<%= attribute %>
<% end -%>
<% end -%>
  end

end
