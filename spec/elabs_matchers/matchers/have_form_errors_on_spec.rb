require "spec_helper"

describe ElabsMatchers::Matchers::HaveFormErrorsOn, :type => :feature do
  describe "#have_form_errors_on" do
    context "with error as sibling to input" do
      let(:html) do
        Capybara.string(%Q{
          <form>
            <span class="error">Can't be blank</span>
            <label for="name">Name</label>
            <input type="text" name="name" id="name" value="" />
          </form>
        })
      end

      it "returns true if the label and the error message is correct" do
        html.should have_form_errors_on("Name", "Can't be blank")
      end

      it "returns false if the label is correct by the error message is wrong" do
        html.should_not have_form_errors_on("Name", "Not good enough")
      end

      it "returns false if the label is wrong by the error message is correct" do
        html.should_not have_form_errors_on("Author", "Can't be blank")
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
            <span class="error">Can't be blank</span>
          </form>
        })
      end

      it "returns true if the label and the error message is correct" do
        html.should have_form_errors_on("Name", "Can't be blank")
      end

      it "returns false if the label is correct by the error message is wrong" do
        html.should_not have_form_errors_on("Name", "Not good enough")
      end

      it "returns false if the label is wrong by the error message is correct" do
        html.should_not have_form_errors_on("Author", "Can't be blank")
      end
    end
  end
end
