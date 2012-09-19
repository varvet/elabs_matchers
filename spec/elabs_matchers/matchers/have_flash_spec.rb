require "spec_helper"

describe ElabsMatchers::Matchers::HaveFlash, :type => :feature do
  subject { Capybara.string(html + "<h1>Elabs</h1>") }

  describe "#have_flash_notice" do
    shared_examples "a have flash notice matcher" do
      it "returns true if given the content of the flash notice" do
        should have_flash_notice("Success")
        expect { should have_flash_notice("Elabs") }.to fail_assertion
      end

      it "returns false if given content outside the flash notice" do
        should_not have_flash_notice("Elabs")
        expect { should_not have_flash_notice("Success") }.to fail_assertion
      end

      it "returns false if the content doesn't exist on the page" do
        should_not have_flash_notice("Failure")
      end
    end

    context "with default configuration" do
      it_behaves_like "a have flash notice matcher" do
        let(:html) { %Q{<div id="flash" class="notice">Success</div>} }
      end
    end

    context "configured with xpath selector" do
      before do
        ElabsMatchers.flash_notice_selector_type = :xpath
        ElabsMatchers.flash_notice_selector = XPath.descendant(:div)[XPath.attr(:class).contains("flash-notice")].to_s
      end

      it_behaves_like "a have flash notice matcher" do
        let(:html) { %Q{<div class="flash-notice">Success</div>} }
      end
    end

    context "configured with xpath selector" do
      before do
        ElabsMatchers.flash_notice_selector_type = :css
        ElabsMatchers.flash_notice_selector = ".flash-notice"
      end

      it_behaves_like "a have flash notice matcher" do
        let(:html) { %Q{<div class="flash-notice">Success</div>} }
      end
    end
  end

  describe "#have_flash_alert" do
    shared_examples "a have flash alert matcher" do
      it "returns true if given the content of the flash alert" do
        should have_flash_alert("Failure")
        expect { should have_flash_alert("Elabs") }.to fail_assertion
      end

      it "returns false if given content outside the flash alert" do
        should_not have_flash_alert("Elabs")
        expect { should_not have_flash_alert("Failure") }.to fail_assertion
      end

      it "returns false if the content doesn't exist on the page" do
        should_not have_flash_alert("Success")
      end
    end

    context "with default configuration" do
      it_behaves_like "a have flash alert matcher" do
        let(:html) { %Q{<div id="flash" class="alert">Failure</div>} }
      end
    end

    context "configured with xpath selector" do
      before do
        ElabsMatchers.flash_alert_selector_type = :xpath
        ElabsMatchers.flash_alert_selector = XPath.descendant(:div)[XPath.attr(:class).contains("flash-alert")].to_s
      end

      it_behaves_like "a have flash alert matcher" do
        let(:html) { %Q{<div class="flash-alert">Failure</div>} }
      end
    end

    context "configured with xpath selector" do
      before do
        ElabsMatchers.flash_alert_selector_type = :css
        ElabsMatchers.flash_alert_selector = ".flash-alert"
      end

      it_behaves_like "a have flash alert matcher" do
        let(:html) { %Q{<div class="flash-alert">Failure</div>} }
      end
    end
  end
end
