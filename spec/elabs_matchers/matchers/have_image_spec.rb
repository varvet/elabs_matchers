require "spec_helper"

describe ElabsMatchers::Matchers::HaveImage, :type => :feature do
  describe "#have_image" do
    let(:html) { Capybara.string(%Q{<div><img src="logo.png" alt="Logo" /></div>}) }

    it "returns true if the image exists on the page" do
      html.should have_image("Logo")
    end

    it "returns false if the image doesn't exist on the page" do
      html.should_not have_image("Avatar")
    end
  end
end
