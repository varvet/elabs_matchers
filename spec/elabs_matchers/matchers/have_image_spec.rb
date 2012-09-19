require "spec_helper"

describe ElabsMatchers::Matchers::HaveImage, :type => :feature do
  describe "#have_image" do
    subject { Capybara.string("<div>" + html + "</div>") }

    shared_examples "a have image matcher" do
      it "returns true if the image exists on the page" do
        should have_image("Logo")
        expect { should have_image("Avatar") }.to fail_assertion
      end

      it "returns false if the image doesn't exist on the page" do
        should_not have_image("Avatar")
        expect { should_not have_image("Logo") }.to fail_assertion
      end
    end

    context "with default configuration" do
      it_behaves_like "a have image matcher" do
        let(:html) { %Q{<img src="logo.png" alt="Logo" />} }
      end
    end

    context "configured with css selector" do
      before do
        ElabsMatchers.image_selector_type = :css
        ElabsMatchers.image_selector = lambda { |src| "img[class='#{src}']" }
      end

      it_behaves_like "a have image matcher" do
        let(:html) { %Q{<img src="logo.png" class="Logo" />} }
      end
    end

    context "configured with xpath selector" do
      before do
        ElabsMatchers.image_selector_type = :xpath
        ElabsMatchers.image_selector = lambda do |src|
          "//img[@class='#{src}']"
        end
      end

      it_behaves_like "a have image matcher" do
        let(:html) { %Q{<img src="logo.png" class="Logo" />} }
      end
    end
  end
end
