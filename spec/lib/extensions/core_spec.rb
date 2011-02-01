require 'spec_helper'

describe Array do

  describe "#to_includes" do

    it "should pass 1 test" do
      [].to_includes.should == []
    end

    it "should pass 2 test" do
      ["foo"].to_includes.should == [:foo]
    end

    it "should pass 3 test" do
      ["foo.bar", "baz", "foo"].to_includes.should == [{:foo => :bar}, :baz, :foo]
    end

    it "should pass 4 test" do
      ["foo.bar.baz", "foo.bar.hola", "foo.hello"].to_includes.should == [{:foo => {:bar => :baz}}, {:foo => {:bar => :hola}}, {:foo => :hello}]
    end

    it "should pass 5 test" do
      ["foo.bar.baz", "foo.bar.hola"].to_includes.should == [{:foo => {:bar => :baz}}, {:foo => {:bar => :hola}}]
    end

  end

end
