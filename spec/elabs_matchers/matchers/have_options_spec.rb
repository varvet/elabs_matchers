require "spec_helper"

describe ElabsMatchers::Matchers::HaveOptions, :type => :feature do
  describe "#have_options" do
    let(:html) { Capybara.string("<select><option value='1'>A</option><option value='2'>B</option></select>") }
    subject { html }

    it "returns true if the select tag have the requested option tags" do
      should have_options("A", "B")
      expect { should have_options("A", "D") }.to fail_assertion
    end

    it "returns true if given some of the options" do
      should have_options("B")

      expect { should have_options("C") }.to fail_assertion
      expect { should_not have_options("A") }.to fail_assertion
      expect { should_not have_options("B") }.to fail_assertion
    end

    it "returns false if the select tag does not have the requested option tags" do
      should_not have_options("A", "C")
      expect { should_not have_options("A", "B") }.to fail_assertion
    end
  end
end
