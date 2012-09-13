require "spec_helper"

describe ElabsMatchers::Matchers::HaveOptions, :type => :feature do
  describe "#have_options" do
    let(:html) { Capybara.string("<select><option value='1'>A</option><option value='2'>B</option></select>") }

    it "returns true if the select tag have the requested option tags" do
      html.should have_options("A", "B")
    end

    it "returns true if given some of the options" do
      html.should have_options("B")
    end

    it "returns false if the select tag does not have the requested option tags" do
      html.should_not have_options("A", "C")
    end
  end
end
