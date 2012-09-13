require "spec_helper"

describe ElabsMatchers::Matchers::OnlyInclude do
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
