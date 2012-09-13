require "spec_helper"

describe ElabsMatchers::Matchers::HaveFields, :type => :feature do
  describe "#have_fields" do
    let(:html) do
      Capybara.string(%Q{
        <form>
          <label for="author">Author</label>
          <input type="text" name="author" id="author" value="Adam" />
          <label for="year">Year</label>
          <input type="text" name="year" id="year" value="2011" />
        </form>
      })
    end
    subject { html }

    it "returns true with several fields if both labels and values are correct" do
      should have_fields("Author" => "Adam", "Year" => "2011")

      expect { should have_fields("Author" => "Adam", "Year" => "2012") }.to fail_assertion
      expect { should have_fields("Author" => "Adam", "Week" => "2011") }.to fail_assertion
    end

    it "returns true with one field if both labels and values are correct" do
      should have_fields("Year" => "2011")
      expect { should have_fields("Week" => "2011") }.to fail_assertion
    end

    it "returns false if the label is correct but the value is not" do
      should_not have_fields("Author" => "David")
      expect { should_not have_fields("Author" => "Adam") }.to fail_assertion
    end

    it "returns false if the label is correct but the value is not" do
      should_not have_fields("Wrong" => "Adam")
    end

    it "returns false if the one of the pairs is incorrect" do
      should_not have_fields("Author" => "Adam", "Year" => "2012")
      expect { should_not have_fields("Author" => "Adam", "Year" => "2011") }.to fail_assertion
    end
  end
end

