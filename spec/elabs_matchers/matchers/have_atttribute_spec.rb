require "spec_helper"

describe ElabsMatchers::Matchers::HaveAttribute, :type => :feature do
  describe "#have_attribute" do
    let(:html) do
      Capybara.string(%Q{<div class="show_for post" id="post_1">
        <p class="wrapper post_status"><strong class="label">Title</strong><br />First</p>
        <p class="wrapper post_status"><strong class="label">Author</strong><br />Adam</p>
      </div>})
    end

    it "returns true when the label exists with the supplied value" do
      html.should have_attribute("Title", "First")
    end

    it "returns false when the label exists with but the value is wrong" do
      html.should_not have_attribute("Title", "Wrong")
    end

    it "returns false when the label does not exist even if the value does" do
      html.should_not have_attribute("Wrong", "First")
    end
  end
end
