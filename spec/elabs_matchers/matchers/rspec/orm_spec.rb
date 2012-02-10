require 'spec_helper'

describe ElabsMatchers::Matchers::Rspec::Orm do
  let(:post) { ElabsMatchers::Orm::Post.create(:title => "New") }

  describe "#persist" do
    it "returns true if the value is the supplied" do
      post.should persist(:title, "Updated")
    end

    it "returns false if the value isn't the supplied" do
      post.stub(:title).and_return("New")
      post.should_not persist(:title, "Updated")
    end
  end

  describe "#allow" do
    subject { post }

    context "with one example value" do
      context "with one attribute" do
        it { should allow("Elabs").as(:title) }
        it { should_not allow("").as(:title) }
      end

  end

end
