require 'spec_helper'

describe ElabsMatchers::Matchers::Capybara do
  describe "have_options" do
    let(:html) { Capybara.string("<select><option value='1'>A</option><option value='2'>B</option></select>") }

    it "passes if the select tag have the requested option tags" do
      html.should have_options("A", "B")
    end

    it "failes if the select tag does not have the requested option tags" do
      expect { html.should have_options("A", "C") }.to raise_error(/expected options to include '\["A", "C"\]' but it had the options \["A", "B"\]/)
    end
  end
end