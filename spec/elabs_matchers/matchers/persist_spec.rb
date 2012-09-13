require "spec_helper"
require "fixtures/post"

describe ElabsMatchers::Matchers::Persist do
  let(:post) { ElabsMatchers::Orm::Post.create(:title => "New", :body => "Lorem") }
  subject { post }

  describe "#persist" do
    it "returns true if the value is the supplied" do
      should persist(:title, "Updated")
      expect { should_not persist(:title, "Updated") }.to fail_assertion
    end

    it "returns false if the value isn't the supplied" do
      post.stub(:title).and_return("New")

      should_not persist(:title, "Updated")
      expect { should persist(:title, "Updated") }.to fail_assertion
    end
  end
end
