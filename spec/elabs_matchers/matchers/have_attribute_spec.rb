require "spec_helper"

describe ElabsMatchers::Matchers::HaveAttribute, :type => :feature do
  describe "#have_attribute" do
    let(:html) do
      Capybara.string(%Q{<div class="show_for post" id="post_1">
        <p class="wrapper post_status"><strong class="label">Title</strong><br />First</p>
        <p class="wrapper post_status"><strong class="label">Author</strong><br />Adam</p>
      </div>})
    end
    subject { html }

    it "returns true when the label exists with the supplied value" do
      should have_attribute("Title", "First")
      should have_attribute("Title", "First")

      expect { should have_attribute("Title", "Last") }.to fail_assertion
      expect { should have_attribute("Name", "First") }.to fail_assertion
    end

    it "returns false when the label exists with but the value is wrong" do
      should_not have_attribute("Title", "Wrong")
      expect { should_not have_attribute("Title", "First") }.to fail_assertion
    end

    it "returns false when the label does not exist even if the value does" do
      should_not have_attribute("Wrong", "First")
    end
  end
end
