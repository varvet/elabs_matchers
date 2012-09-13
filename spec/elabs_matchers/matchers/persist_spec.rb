require 'spec_helper'

describe ElabsMatchers::Matchers::Persist do
  let(:post) { ElabsMatchers::Orm::Post.create(:title => "New", :body => "Lorem") }

  describe "#persist" do
    it "returns true if the value is the supplied" do
      post.should persist(:title, "Updated")
    end

    it "returns false if the value isn't the supplied" do
      post.stub(:title).and_return("New")
      post.should_not persist(:title, "Updated")
    end
  end
end
