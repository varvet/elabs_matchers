require "spec_helper"

describe ElabsMatchers::Matchers::ContainHash do
  describe "#contain_hash" do
    context "with a simple hash" do
      subject { { "foo" => "bar", "baz" => "quox" } }

      it "returns true with the given value" do
        should contain_hash({ "foo" => "bar" })
        should contain_hash({ "baz" => "quox" })

        expect { should contain_hash({ "foo" => "baz" }) }.to fail_assertion
        expect { should contain_hash({ "bar" => "bar" }) }.to fail_assertion
      end

      it "returns false if key or value don't match" do
        should_not contain_hash({ "foo" => "quox" })
        should_not contain_hash({ "baz" => "bar" })

        expect { should_not contain_hash({ "foo" => "bar" }) }.to fail_assertion
      end
    end

    context "with a simple array" do
      subject { %w[foo quox] }

      it "returns true with the given value" do
        should contain_hash(["foo"])
        should contain_hash(["quox"])
        should contain_hash(%w[foo quox])

        expect { should contain_hash(["bar"]) }.to fail_assertion
      end

      it "returns false if the array doesn't contain the given value" do
        should_not contain_hash(["blah"])
        expect { should_not contain_hash(["foo"]) }.to fail_assertion
      end
    end

    context "with a nested hash" do
      subject { { "foo" => { "foo1" => "bar1", "foo2" => "bar2" }} }

      it "returns true with the given value" do
        should contain_hash({ "foo" => { "foo1" => "bar1" }})
        should contain_hash({ "foo" => { "foo2" => "bar2" }})

        expect { should contain_hash({ "foo" => { "foo1" => "bar2" }}) }.to fail_assertion
        expect { should contain_hash({ "bar" => { "foo1" => "bar1" }}) }.to fail_assertion
        expect { should contain_hash({ "foo" => { "foo2" => "bar1" }}) }.to fail_assertion
      end

      it "returns false if key or value don't match" do
        should_not contain_hash({ "foo" => { "foo1" => "bar2" }})
        should_not contain_hash({ "foo" => { "foo2" => "bar1" }})
        should_not contain_hash({ "foo" => { "monkey" => "baz" }})
        should_not contain_hash({ "foo" => "monkey" })

        expect { should_not contain_hash({ "foo" => { "foo1" => "bar1" }}) }.to fail_assertion
      end
    end

    context "with a nested array" do
      subject { { "foo" => ["quox", { "bar" => "baz" }]} }

      it "returns true with the given value" do
        should contain_hash({ "foo" => [{ "bar" => "baz" }]})
        should contain_hash({ "foo" => ["quox"]})

        expect { should contain_hash({ "foo" => [{ "bar" => "quox" }] }) }.to fail_assertion
        expect { should contain_hash({ "foo" => [{ "foo" => "baz" }] }) }.to fail_assertion
        expect { should contain_hash({ "bar" => [{ "bar" => "baz" }] }) }.to fail_assertion
        expect { should contain_hash({ "foo" => ["bar"] }) }.to fail_assertion
      end

      it "returns false if array doesn't contain the given sequence" do
        should_not contain_hash({ "foo" => [{ "bar" => "quox" }]})
        should_not contain_hash({ "foo" => ["bar"]})
        should_not contain_hash({ "foo" => "monkey"})

        expect { should_not contain_hash({ "foo" => [{ "bar" => "baz" }] }) }.to fail_assertion
        expect { should_not contain_hash({ "foo" => ["quox"] }) }.to fail_assertion
      end
    end
  end
end
