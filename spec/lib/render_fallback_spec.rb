require 'spec_helper'

describe "Rendering" do

  include RSpec::Rails::RequestExampleGroup

  it "should render native temptate if exists" do
    get admin_users_url
    response.should render_template('admin/users/index')
  end

  it "should fallback to puffer template if native not exists" do
    get admin_posts_url
    response.should render_template('puffer/index')
  end

end
