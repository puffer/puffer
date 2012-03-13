require 'spec_helper'

describe "Mutate" do

  context 'unexistant model' do
    class SomeController < Puffer::Base
    end

    specify{expect {SomeController.model}.to raise_error(Puffer::NoModelError)}
  end

  context 'existant model' do
    class Article < ActiveRecord::Base
    end
    class ArticlesController < Puffer::Base
    end

    specify{ArticlesController.model.should == Article}
  end

end