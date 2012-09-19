require "spec_helper"

describe ElabsMatchers::Matchers::HaveHeader, :type => :feature do
  describe "#have_header" do
    let(:html) { Capybara.string(%Q{<div><h1>Elabs</h1><h2>Bespoke</h2><h3>Development</h3></div>}) }
    subject { html }

    it "returns true if given the content of a h1 tag" do
      should have_header("Elabs")
      expect { should have_header("Development") }.to fail_assertion
    end

    it "returns true if given the content of a h2 tag" do
      should have_header("Bespoke")
    end

    it "returns false if given the content of a h3 tag" do
      should_not have_header("Development")

      expect { should_not have_header("Elabs") }.to fail_assertion
      expect { should_not have_header("Bespoke") }.to fail_assertion
    end

    it "returns false if the content doesn't exist on the page" do
      should_not have_header("Bugs")
    end

    shared_examples "a configured have header matcher" do
      it "returns true if given the content of a h3" do
        should have_header("Development")
        expect { should_not have_header("Development") }.to fail_assertion
      end

      it "returns false if given the content of a h2" do
        should_not have_header("Bespoke")
        expect { should have_header("Bespoke") }.to fail_assertion
      end
    end

    context "configured with a css selector" do
      before { ElabsMatchers.header_selector = "h1,h3" }
      it_behaves_like "a configured have header matcher"
    end

    context "configured with xpath selector" do
      before do
        ElabsMatchers.header_selector_type = :xpath
        ElabsMatchers.header_selector = XPath.descendant(:h1, :h3).to_s
      end

      it_behaves_like "a configured have header matcher"
    end
  end
end
