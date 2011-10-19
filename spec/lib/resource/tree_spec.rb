require 'spec_helper'

describe "Tree" do

  it "should generate proper tree" do
    Rails.application.routes.resources_tree.map(&:to_struct).should == [
      {:scope => :admin, :current => :users, :children => [:profile, :posts], :ancestors => []},
      {:scope => :admin, :current => :profile, :children => [:tags], :ancestors => [:users]},
      {:scope => :admin, :current => :tags, :children => [], :ancestors => [:users, :profile]},
      {:scope => :admin, :current => :posts, :children => [:categories, :tags], :ancestors => [:users]},
      {:scope => :admin, :current => :categories, :children => [], :ancestors => [:users, :posts]},
      {:scope => :admin, :current => :tags, :children => [], :ancestors => [:users, :posts]},
      {:scope => :admin, :current => :profiles, :children => [:tags], :ancestors => []},
      {:scope => :admin, :current => :tags, :children => [], :ancestors => [:profiles]},
      {:scope => :admin, :current => :posts, :children => [:user, :categories], :ancestors => []},
      {:scope => :admin, :current => :user, :children => [], :ancestors => [:posts]},
      {:scope => :admin, :current => :categories, :children => [], :ancestors => [:posts]},
      {:scope => :admin, :current => :tagged_posts, :children => [:user, :categories, :tags], :ancestors => []},
      {:scope => :admin, :current => :user, :children => [], :ancestors => [:tagged_posts]},
      {:scope => :admin, :current => :categories, :children => [], :ancestors => [:tagged_posts]},
      {:scope => :admin, :current => :tags, :children => [], :ancestors => [:tagged_posts]},
      {:scope => :admin, :current => :categories, :children => [:posts], :ancestors => []},
      {:scope => :admin, :current => :posts, :children => [], :ancestors => [:categories]},
      {:scope => :admin, :current => :news, :children => [], :ancestors => []},
      {:scope => :admin, :current => :puffer_users, :children => [], :ancestors => []},
      {:scope => :orms, :current => :active_record_orm_primals, :children => [], :ancestors => []},
      {:scope => :orms, :current => :mongoid_orm_primals, :children => [], :ancestors => []},
      {:scope => :admin, :current => :session, :children => [], :ancestors => []}
    ]
  end
end