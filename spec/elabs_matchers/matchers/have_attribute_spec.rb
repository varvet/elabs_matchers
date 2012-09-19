require "spec_helper"

describe ElabsMatchers::Matchers::HaveAttribute, :type => :feature do
  describe "#have_attribute" do
    subject { Capybara.string(html) }

    shared_examples "a have attribute matcher" do
      it "returns true when the label exists with the supplied value" do
        should have_attribute("Title", "First")
        should have_attribute("Title", "First")

        expect { should have_attribute("Title", "Last") }.to fail_assertion
        expect { should have_attribute("Name", "First") }.to fail_assertion
      end

      it "returns false when the label exists with but the value is wrong" do
        should_not have_attribute("Title", "Wrong")
        expect { should_not have_attribute("Title", "First") }.to fail_assertion
      end

      it "returns false when the label does not exist even if the value does" do
        should_not have_attribute("Wrong", "First")
      end
    end

    context "using default configuration" do
      it_behaves_like "a have attribute matcher" do
        let(:html) do
          %Q{<div class="show_for post" id="post_1">
            <p class="wrapper post_status"><strong class="label">Title</strong><br />First</p>
            <p class="wrapper post_status"><strong class="label">Author</strong><br />Adam</p>
          </div>}
        end
      end
    end

    context "configured with a css selector" do
      before do
        ElabsMatchers.attribute_selector_type = :css
        ElabsMatchers.attribute_selector = lambda do |label, value|
          "a[title='#{label}'] img[alt='#{value}']"
        end
      end

      it_behaves_like "a have attribute matcher" do
        let(:html) { %Q{<div><a title="Title"><img alt="First" src="/f.png"></a><a title="Author"><img alt="Adam" src="/a.png"></a></div>} }
      end
    end

    context "configured with xpath selector" do
      before do
        ElabsMatchers.attribute_selector_type = :xpath
        ElabsMatchers.attribute_selector = lambda do |label, value|
          XPath.generate do |x|
            x.descendant(:a)[x.attr(:title).contains(label)][x.contains(value)]
          end
        end
      end

      it_behaves_like "a have attribute matcher" do
        let(:html) { %Q{<div><a title="Title">First</a><a title="Author">Adam</a></div>} }
      end
    end
  end
end
