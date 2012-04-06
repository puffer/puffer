require 'clearance/testing'
require 'controllers/sessions/base_shared'

describe Puffer::Sessions::Clearance do
  controller do
    include Clearance::Authentication

    setup do
      model_name :clearance_user
    end

    def current_puffer_user
      current_user
    end

    def authenticate
      model.authenticate(resource.attributes[:email], resource.attributes[:password])
    end
  end

  it_behaves_like "a session controller" do
    let(:user) {Fabricate :clearance_user}
    let(:param_key) {:clearance_user}
  end
end