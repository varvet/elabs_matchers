require "spec_helper"

describe ElabsMatchers::Matchers::OnlyInclude do
  subject { %w[foo bar] }

  describe "#only_include" do
    it "returns true when all the elements are passed in the wrong order" do
      should only_include("bar", "foo")
      expect { should only_include("quox", "foo") }.to fail_assertion
    end

    it "returns false when given a present element several times" do
      should_not only_include("foo", "foo")
      expect { should only_include("foo", "foo") }.to fail_assertion
    end

    it "returns true when all the elements are passed in the correct order" do
      should only_include("foo", "bar")
      expect { should only_include("quox", "baz") }.to fail_assertion
    end

    it "returns false when one or more element is missing" do
      should_not only_include("foo")
      expect { should_not only_include("bar", "foo") }.to fail_assertion
    end

    it "returns false when one of the element is not in the list" do
      should_not only_include("foo", "bar", "baz")
      expect { should_not only_include("foo", "bar") }.to fail_assertion
    end
  end
end
