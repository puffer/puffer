require 'spec_helper'

describe "Tree" do

  it "should generate proper tree" do
    Rails.application.routes.resources_tree.map(&:to_struct).should == [
      {:namespace => :admin, :current => :users, :children => [:profile, :posts], :ancestors => []},
      {:namespace => :admin, :current => :profile, :children => [:tags], :ancestors => [:users]},
      {:namespace => :admin, :current => :tags, :children => [], :ancestors => [:users, :profile]},
      {:namespace => :admin, :current => :posts, :children => [:categories, :tags], :ancestors => [:users]},
      {:namespace => :admin, :current => :categories, :children => [], :ancestors => [:users, :posts]},
      {:namespace => :admin, :current => :tags, :children => [], :ancestors => [:users, :posts]},
      {:namespace => :admin, :current => :profiles, :children => [:tags], :ancestors => []},
      {:namespace => :admin, :current => :tags, :children => [], :ancestors => [:profiles]},
      {:namespace => :admin, :current => :posts, :children => [:user, :categories], :ancestors => []},
      {:namespace => :admin, :current => :user, :children => [], :ancestors => [:posts]},
      {:namespace => :admin, :current => :categories, :children => [], :ancestors => [:posts]},
      {:namespace => :admin, :current => :tagged_posts, :children => [:user, :categories, :tags], :ancestors => []},
      {:namespace => :admin, :current => :user, :children => [], :ancestors => [:tagged_posts]},
      {:namespace => :admin, :current => :categories, :children => [], :ancestors => [:tagged_posts]},
      {:namespace => :admin, :current => :tags, :children => [], :ancestors => [:tagged_posts]},
      {:namespace => :admin, :current => :categories, :children => [:posts], :ancestors => []},
      {:namespace => :admin, :current => :posts, :children => [], :ancestors => [:categories]},
      {:namespace => :admin, :current => :news, :children => [], :ancestors => []},
      {:namespace => :admin, :current => :puffer_users, :children => [], :ancestors => []},
      {:namespace => :orms, :current => :mongoid_orms, :children => [], :ancestors => []},
      {:namespace => :admin, :current => :session, :children => [], :ancestors => []}
    ]
  end
end