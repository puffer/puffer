# Puffer - YARAI (Yet Another Rails Admin Interface). Rails 3.1 only.

Puffer was created to help a project owner or moderators view and edit all the project's data models. It's compatible with Rails 3.1 only.

## Discussion and help

puffer@conference.jabber.org

## Key features

* Full Rails integration. Puffer has no configuration, just a DSL to create interfaces. And this DSL depends on Rails conventions.
* Flexibility. Puffer designed to be as flexible as possible, so you can create your own modules easily.
* I18n. Surely.
* Bla bla

## Installation.

You can install puffer as a gem:

`gem install puffer`

Or in Gemfile:

`gem "puffer"`

## Introduction.

Let's assume this is the data structure of your project:

```
create_table "users", :force => true do |t|
  t.string   "email"
  t.string   "password"
  t.datetime "created_at"
  t.datetime "updated_at"
end

create_table "posts", :force => true do |t|
  t.integer  "user_id"
  t.string   "title"
  t.text     "body"
  t.datetime "created_at"
  t.datetime "updated_at"
end
```

And let's also assume your models look like this:

```
class User < ActiveRecord::Base
  has_many :posts
  validates_presence_of :email, :password
  validates_length_of :password, :minimum => 6
end

class Profile < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :surname
end
```

First, let's generate Puffer controllers:

`rails g puffer:controller User`

and

`rails g puffer:controller Post`

This will generate this:

```
class Admin::PostsController < Puffer::Base
  setup do
    group :posts
  end

  index do
    field :id
    field :user_id
    field :title
    field :body
    field :created_at
    field :updated_at
  end

  form do
    field :id
    field :user_id
    field :title
    field :body
    field :created_at
    field :updated_at
  end

end
```

Puffer's controller DSL creates all the actions you need. Next step: routing.

```
namespace :admin do
  resources :users do
    resources :posts
  end
  resources :posts
end
```

Let me explain this feature. Puffer tracks all the nested resources. So, with this routing structure we can access, for example, only specified user's posts:

`/admin/users/1/post`

Routing nesting defines admin interface resources nesting.

## Advanced usage

Puffer can be used in other namespaces than admin:

`rails g puffer:controller moderator/posts`

And we'll get posts controller for moderators:

```
class Moderator::PostsController < Puffer::Base
  before_filter :require_moderator

  setup do
    destroy false
    group :posting
  end

  index do
    field :user_id
    field :title
    field :body
  end

  form do
    field :user_id
    field :title
    field :body
    field :created_at
    field :updated_at
  end
end
```

As you can see, moderators can't destroy posts. The moderator's post controller is placed in the Posting tab of the admin interface.

Finally, don't forget about routing:

```
namespace :moderator do
  resources :posts
end
```