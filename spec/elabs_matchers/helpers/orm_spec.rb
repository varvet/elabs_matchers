require 'spec_helper'

describe ElabsMatchers::Orm do
  describe "#save_and_reload" do
    let(:post) { Post.create(:title => "New") }

    it "it saves the record" do
      post.title = "Updated"
      save_and_reload(post).title.should == "Updated"
    end

    it "it reloads the record" do
      save_and_reload(post).object_id.should_not == post.object_id
    end
  end
end
