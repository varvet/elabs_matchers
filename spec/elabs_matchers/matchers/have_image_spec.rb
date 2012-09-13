require "spec_helper"

describe ElabsMatchers::Matchers::HaveImage, :type => :feature do
  describe "#have_image" do
    let(:html) { Capybara.string(%Q{<div><img src="logo.png" alt="Logo" /></div>}) }
    subject { html }

    it "returns true if the image exists on the page" do
      should have_image("Logo")
      expect { should have_image("Avatar") }.to fail_assertion
    end

    it "returns false if the image doesn't exist on the page" do
      should_not have_image("Avatar")
      expect { should_not have_image("Logo") }.to fail_assertion
    end
  end
end
