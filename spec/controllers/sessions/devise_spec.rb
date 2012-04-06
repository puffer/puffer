require 'controllers/sessions/base_shared'

describe Puffer::Sessions::Devise do
  include Devise::TestHelpers

  controller do
    include Devise::Controllers::Helpers

    setup do
      model_name :devise_user
    end

    def current_puffer_user
      current_devise_user
    end
  end

  it_behaves_like "a session controller" do
    let(:user) {Fabricate :devise_user}
    let(:param_key) {:devise_user}
  end
end