class Admin::TaggedPostsController < Admin::PostsController

  form do
    super_fields
    field :tags
  end

end
