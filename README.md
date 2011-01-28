# Puffer - YARAI (Yet Another Rails Admin Interface). Rails 3 only.

Puffer was created to help project owner or moderators view and edit all the project`s data models. It is rails 3 only

## Keyfeatures

* Full rails integration. Puffer has no configs, just DSL to create interfaces. And this DLS depends on rails convensions.
* Flexibility. Puffer designed to be as flexible as possible, so you can create your own modules easily.
* I18n. Surely.
* Bla bla

## Installation.

You can instal puffer as a gem:
<pre>gem install puffer</pre>
Or in Gemfile:
<pre>gem "puffer"</pre>
Next step is:
<pre>rails g puffer:install</pre>
This will install main puffer config file in your initializers and some css/js.

## Introduction.

So, you have some data structure of your project. Let it`ll be like this:

<pre>
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
</pre>

Also, you have two models:
<pre>
class User < ActiveRecord::Base
  has_many :posts
  validates_presence_of :email, :password
  validates_length_of :password, :minimum => 6
end
</pre>
<pre>
class Profile < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :name, :surname
end
</pre>

At first, lets generate puffers controllers:
<pre>rails g puffer:controller User</pre>
and
<pre>rails g puffer:controller Post</pre>

This will generate a kind of:
<pre>
class Admin::PostsController < Puffer::Base
  before_filter :i_didnt_forget_to_protect_this

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
</pre>
