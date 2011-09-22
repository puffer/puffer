require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the PufferHelper. For example:
#
# describe PufferHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe PufferHelper do

  it "generates namespaces navigation" do
    helper.stub(:puffer_namespace).and_return(:admin)
    
    navigation = []
    helper.puffer_namespaces_navigation do |*args|
      navigation.push args
    end

    navigation.should == [
      [:admin, "/admin", true],
      [:orms, "/orms", false]
    ]
  end

  it "generates groups navigation" do
    helper.stub(:puffer_namespace).and_return(:admin)
    helper.stub(:resource).and_return mock(:resource_node => mock, :root => mock(:resource_node => mock(:group => :posting)))

    navigation = []
    helper.puffer_groups_navigation do |*args|
      navigation.push args
    end

    navigation.should == [
      [:users, "/admin/users", false],
      [:posting, "/admin/posts", true],
      [:news, "/admin/news", false]
    ]
  end

  it "generates resources navigation" do
    helper.stub(:puffer_namespace).and_return(:admin)
    helper.stub(:configuration).and_return mock(:group => :posting)
    helper.stub(:resource).and_return mock(:resource_node => mock, :root => mock(:resource_node => Rails.application.routes.resources_tree[15]))

    navigation = []
    helper.puffer_resources_navigation do |*args|
      navigation.push args
    end

    navigation.should == [
      ["Post", "/admin/posts", false],
      ["Tagged post", "/admin/tagged_posts", false],
      ["Category", "/admin/categories", true]
    ]
  end

end
