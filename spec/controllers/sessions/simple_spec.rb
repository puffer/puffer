require 'controllers/sessions/base_shared'

describe Puffer::Sessions::Simple do
  controller do
    def current_puffer_user
      model.to_adapter.get(session[:puffer_user_id])
    end
  end

  it_behaves_like "a session controller" do
    let(:user) {Fabricate :puffer_user}
    let(:param_key) {:puffer_user}
  end
end