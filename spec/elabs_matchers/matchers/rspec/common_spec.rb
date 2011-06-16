require 'spec_helper'

describe ElabsMatchers::Matchers::Rspec::Common do
  describe '#contain_hash' do
    context "with a simple hash" do
      it "returns true with the given value" do
        { "foo" => "bar", "baz" => "quox" }.should contain_hash({ "foo" => "bar" })
        { "foo" => "bar", "baz" => "quox" }.should contain_hash({ "baz" => "quox" })
      end

      it "returns false if key or value don't match" do
        { "foo" => "bar", "baz" => "quox" }.should_not contain_hash({ "foo" => "quox" })
        { "foo" => "bar", "baz" => "quox" }.should_not contain_hash({ "baz" => "bar" })
      end
    end

    context "with a simple array" do
      it "returns true with the given value" do
        [ "foo", "quox" ].should contain_hash(["foo"])
        [ "foo", "quox" ].should contain_hash(["quox"])
        [ "foo", "quox" ].should contain_hash(["foo", "quox"])
      end

      it "returns false if the array doesn't contain the given value" do
        [ "foo", "baz" ].should_not contain_hash(["blah"])
      end
    end

    context "with a nested hash" do
      it "returns true with the given value" do
        { "foo" => { "foo1" => "bar1", "foo2" => "bar2" }}.should contain_hash({ "foo" => { "foo1" => "bar1" }})
        { "foo" => { "foo1" => "bar1", "foo2" => "bar2" }}.should contain_hash({ "foo" => { "foo2" => "bar2" }})
      end

      it "returns false if key or value don't match" do
        { "foo" => { "foo1" => "bar1", "foo2" => "bar2" }}.should_not contain_hash({ "foo" => { "foo1" => "bar2" }})
        { "foo" => { "foo1" => "bar1", "foo2" => "bar2" }}.should_not contain_hash({ "foo" => { "foo2" => "bar1" }})
        { "foo" => { "foo1" => "bar1", "foo2" => "bar2" }}.should_not contain_hash({ "foo" => { "monkey" => "baz" }})
        { "foo" => { "foo1" => "bar1", "foo2" => "bar2" }}.should_not contain_hash({ "foo" => "monkey" })
      end
    end

    context "with a nested array" do
      it "returns true with the given value" do
        { "foo" => ['quox', { 'bar' => 'baz'}]}.should contain_hash({ "foo" => [{ "bar" => "baz" }]})
        { "foo" => ['quox', { 'bar' => 'baz'}]}.should contain_hash({ "foo" => ["quox"]})
      end

      it "returns false if array doesn't contain the given sequence" do
        { "foo" => ['quox', { 'bar' => 'baz'}]}.should_not contain_hash({ "foo" => [{ "bar" => "quox" }]})
        { "foo" => ['quox', { 'bar' => 'baz'}]}.should_not contain_hash({ "foo" => ["bar"]})
        { "foo" => ['quox', { 'bar' => 'baz'}]}.should_not contain_hash({ "foo" => "monkey"})
      end
    end
  end

  describe "#only_include" do
    it "returns true when all the elements are passed in the wrong order" do
      %w[foo bar].should only_include("bar", "foo")
    end

    it "returns true when all the elements are passed in the correct order" do
      %w[foo bar].should only_include("foo", "bar")
    end

    it "returns false when one or more element is missing" do
      %w[foo bar].should_not only_include("foo")
    end

    it "returns false when one of the element is not in the list" do
      %w[foo bar].should_not only_include("foo", "bar", "baz")
    end
  end
end
