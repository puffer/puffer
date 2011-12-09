require 'controllers/sessions/base_shared'

describe Puffer::Sessions::Clearance do
  Puffer::Sessions::Clearance.send :include, Clearance::Authentication
  controller do
    setup do
      model_name :clearance_user
    end

    def current_puffer_user
      current_user
    end
  end

  it_behaves_like "a session controller" do
    let(:user) {Fabricate :clearance_user}
    let(:param_key) {:clearance_user}
  end
end