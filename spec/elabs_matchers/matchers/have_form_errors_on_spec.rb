require "spec_helper"

describe ElabsMatchers::Matchers::HaveFormErrorsOn, :type => :feature do
  subject do
    Capybara.string("<form>" + html + "</form>")
  end

  shared_examples "a form error matcher" do
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

  describe "#have_form_errors_on" do
    context "with error as sibling to input" do
      it_behaves_like "a form error matcher" do
        let(:html) { %Q{
          <span class="error">can't be blank</span>
          <label for="name">Name</label>
          <input type="text" name="name" id="name" value="" /> }
        }
      end
    end

    context "with input nested in label" do
      it_behaves_like "a form error matcher" do
        let(:html) { %Q{
          <label for="name">
            <input type="text" name="name" id="name" value="" />
            Name
          </label>
          <span class="error">can't be blank</span>}
        }
      end
    end
  end

  context "with error span outside input container" do
    it_behaves_like "a form error matcher" do
      let(:html) { %Q{
        <div class="input string required field_with_errors">
          <fieldset>
            <label for="name">Name</label>
            <input id="name" name="name" type="text" value="">
          </fieldset>
          <span class="error">can't be blank</span>
        </div> }
      }
    end
  end

  context "with twitter bootstrap markup normal inputs" do
    it_behaves_like "a form error matcher" do
      let(:html) { %Q{
        <div class="control-group error">
          <label for="name">Name</label>
          <div class="controls">
            <input id="name" name="name" type="text" value="">
            <p>can't be blank</p>
          </div>
        </div>}
      }
    end
  end

  context "with custom configured xpath selector" do
    before do
      ElabsMatchers.form_errors_on_selector = %Q{..//..//li[contains(@class,'error')]}
    end

    it_behaves_like "a form error matcher" do
      let(:html) { %Q{
        <ul>
          <li><label for="name">Name</label></li>
          <li><input type="text" name="name" id="name" value="" /></li>
          <li class="error">can't be blank</li>
        </ul>}
      }
    end
  end
end
