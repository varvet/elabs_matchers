require "spec_helper"

describe ElabsMatchers::Matchers::HaveHeader, :type => :feature do
  describe "#have_header" do
    let(:html) { Capybara.string(%Q{<div><h1>Elabs</h1><h2>Bespoke</h2><h3>Development</h3></div>}) }

    it "returns true if given the content of a h1 tag" do
      html.should have_header("Elabs")
    end

    it "returns true if given the content of a h2 tag" do
      html.should have_header("Bespoke")
    end

    it "returns false if given the content of a h3 tag" do
      html.should_not have_header("Development")
    end

    it "returns false if the content doesn't exist on the page" do
      html.should_not have_header("Bugs")
    end
  end
end
