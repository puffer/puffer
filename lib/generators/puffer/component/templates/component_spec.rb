require 'spec_helper'

describe <%= @name.camelize %>Component do

  include RSpec::Rails::RequestExampleGroup

  context 'index' do

    it 'should render index component'

  end

  context 'form' do

    it 'should render form component'

  end

end