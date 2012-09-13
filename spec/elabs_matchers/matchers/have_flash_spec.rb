require "spec_helper"

describe ElabsMatchers::Matchers::HaveFlash, :type => :feature do
  describe "#have_flash_notice" do
    let(:html) { Capybara.string(%Q{<div id="flash" class="notice">Success</div><h1>Elabs</h1>}) }

    it "returns true if given the content of the flash notice" do
      html.should have_flash_notice("Success")
    end

    it "returns false if given content outside the flash notice" do
      html.should_not have_flash_notice("Elabs")
    end

    it "returns false if the content doesn't exist on the page" do
      html.should_not have_flash_notice("Failure")
    end
  end

  describe "#have_flash_alert" do
    let(:html) { Capybara.string(%Q{<div id="flash" class="alert">Error</div><h1>Elabs</h1>}) }

    it "returns true if given the content of the flash alert" do
      html.should have_flash_alert("Error")
    end

    it "returns false if given content outside the flash alert" do
      html.should_not have_flash_alert("Elabs")
    end

    it "returns false if the content doesn't exist on the page" do
      html.should_not have_flash_alert("Success")
    end
  end
end
