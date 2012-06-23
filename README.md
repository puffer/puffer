[![Build Status](https://secure.travis-ci.org/puffer/puffer.png)](http://travis-ci.org/puffer/puffer)

# Achtung!

It's better to install Puffer from the HEAD of ruby repo now.

<pre>gem "puffer", :git => "git://github.com/puffer/puffer.git"</pre>

# Puffer — YARAI (Yet Another Rails Admin Interface)

Puffer was created to help a project owner or moderators view and
edit all the project's data models.

**It's compatible with Rails >= 3.1 only.**

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

## Post-installation actions.

First of all, it is nessesary to create security system for admin
interface. It consists of two parts: user model and sessions controller.
There are two cases for it:

### Integrated auth system

Simple integarted auth system. To activate it - just execute
`rails g puffer:puffer_user`. This will create model, migrations, controller
and routes for PufferUser model. Also, default sessions controller which
uses PufferUser model already in engine. So, both parts of auth system are
ready for usage. Also there is mongoid backend for PufferUser storage.
See generator usage for details.

### External auth system

If application already use some kind of auth system like a devise, clearance
or sorcery - you should use corresponding SessionsController backend.
Just create app/controllers/admin/sessions_controller.rb in your application
directory to redefine default SessionsController.

The content of file depends on used auth system. There are several backends
for SessionsController exists in Puffer. I.e. for clearance use:

```
class Admin::SessionsController < Puffer::Sessions::Clearance
end
```

See https://github.com/puffer/puffer/tree/master/lib/puffer/backends/controllers/sessions
for the list of backends. Also you can create your own backend.

If you use app's auth system, you might want to redefine access rules. The simpliest way
for it - is to redefine `current_puffer_use` or `has_puffer_access?` methods in controller
or implement `has_role?` method for your user model. See https://github.com/puffer/puffer/blob/master/lib/puffer/controller/auth.rb for details.


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

***

Thanks to [Dmitry Ustalov](http://eveel.ru) for the name of Puffer along with the Clearance integration.
