class <%= controller_name %>Controller < Puffer::Base
  before_filter :i_didnt_forget_to_protect_this

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
