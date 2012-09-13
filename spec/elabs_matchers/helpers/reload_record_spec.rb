require "spec_helper"
require "fixtures/post.rb"

describe ElabsMatchers::Helpers::ReloadRecord do
  let(:post) { ElabsMatchers::Orm::Post.create(:title => "New") }

  describe "#save_and_reload" do
    it "it saves the record" do
      post.title = "Updated"
      save_and_reload(post).title.should == "Updated"
    end

    it "it reloads the record" do
      save_and_reload(post).object_id.should_not == post.object_id
    end
  end

  describe "#reload" do
    it "it reloads the record" do
      reload(post).object_id.should_not == post.object_id
    end
  end
end
