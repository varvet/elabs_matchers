require "spec_helper"

describe ElabsMatchers::Matchers::HaveFormErrorsOn, :type => :feature do
  subject { html }

  describe "#have_form_errors_on" do
    context "with error as sibling to input" do
      let(:html) do
        Capybara.string(%Q{
          <form>
            <span class="error">can't be blank</span>
            <label for="name">Name</label>
            <input type="text" name="name" id="name" value="" />
          </form>
        })
      end

      it "returns true if the label and the error message is correct" do
        should have_form_errors_on("Name", "can't be blank")

        expect { should have_form_errors_on("Name", "must be royal") }.to fail_assertion
        expect { should have_form_errors_on("Message", "can't be blank") }.to fail_assertion
      end

      it "returns false if the label is correct by the error message is wrong" do
        should_not have_form_errors_on("Name", "Not good enough")
        expect { should_not have_form_errors_on("Name", "can't be blank") }.to fail_assertion
      end

      it "returns false if the label is wrong by the error message is correct" do
        should_not have_form_errors_on("Author", "can't be blank")
      end
    end

    context "with input nested in label" do
      let(:html) do
        Capybara.string(%Q{
          <form>
            <label for="name">
              <input type="text" name="name" id="name" value="" />
              Name
            </label>
            <span class="error">can't be blank</span>
          </form>
        })
      end

      it "returns true if the label and the error message is correct" do
        should have_form_errors_on("Name", "can't be blank")
        expect { should have_form_errors_on("Name", "must be royal") }.to fail_assertion
      end

      it "returns false if the label is correct by the error message is wrong" do
        should_not have_form_errors_on("Name", "Not good enough")
        expect { should_not have_form_errors_on("Name", "can't be blank") }.to fail_assertion
      end

      it "returns false if the label is wrong by the error message is correct" do
        should_not have_form_errors_on("Author", "can't be blank")
      end
    end
  end
end
