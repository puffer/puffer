# Puffer — YARAI (Yet Another Rails Admin Interface)

Puffer was created to help a project owner or moderators view and
edit all the project's data models.

**It's compatible with Rails 3.1 only.**

## Discussion and help

<xmpp:puffer@conference.jabber.org>

## Key features

* Full Ruby on Rails integration. Puffer has no configuration files, but a
DSL to define administration interfaces. This DSL follows the Rails
conventions.
* Flexibility. Puffer designed to provide much flexibility as possible,
so you can create your own extensions without any design issues.
* Internationalization. Surely, enjoy the native Rails i18n subsystem.
* Puffer supports different ORMs or ODMs through the `orm_adapter` gem.
Currently, we can work with ActiveRecord and Mongoid.

## Installation.

You can install puffer as a gem:

`gem install puffer`

Or in Gemfile:

`gem "puffer"`

## Introduction.

Let's assume this is the data structure of your application:

```ruby
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

```ruby
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

First, let's generate the Puffer controllers:

`rails g puffer:controller User`

and

`rails g puffer:controller Post`

This will generate the following code:

```ruby
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

Puffer's DSL creates all the actions you need. Next step is routing.

```ruby
namespace :admin do
  resources :users do
    resources :posts
  end
  resources :posts
end
```

Let me explain this feature. Puffer tracks all the nested resources.
For instance, according to our routing definitions, we can access only
specified posts of our user:

`/admin/users/1/post`

Routing nesting implies the admin resources nesting.

## Advanced usage

Puffer can work in different namespaces:

`rails g puffer:controller moderator/posts`

And we'll get posts controller for moderators:

```ruby
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

As you can see, moderators can't destroy posts. The moderator's post
controller is placed in the Posting tab of the admin interface.

Finally, don't forget about routing:

```ruby
namespace :moderator do
  resources :posts
end
```

Have a nice day and let Puffer rock for you.
