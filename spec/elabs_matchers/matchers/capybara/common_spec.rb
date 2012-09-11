require 'spec_helper'

describe ElabsMatchers::Matchers::Capybara::Common, :type => :feature do
  describe "#have_options" do
    let(:html) { Capybara.string("<select><option value='1'>A</option><option value='2'>B</option></select>") }

    it "returns true if the select tag have the requested option tags" do
      html.should have_options("A", "B")
    end

    it "returns true if given some of the options" do
      html.should have_options("B")
    end

    it "returns false if the select tag does not have the requested option tags" do
      html.should_not have_options("A", "C")
    end
  end

  describe "#have_table_row" do
    let(:html) do
      Capybara.string(%Q{
        <table>
          <caption>Posts</caption>
          <thead>
            <tr><th>Title</th><th>Author</th></tr>
          </thead>
          <tbody>
            <tr><td>First</td><td>Adam</td></tr>
            <tr><td>Second</td><td>David</td></tr>
          </tbody>
        </table>
      })
    end

    it "returns true when the one of the pairs in the row exists" do
      html.should have_table_row("Posts", "Title" => "First")
    end

    it "returns true when the all of the pairs in the row exists" do
      html.should have_table_row("Posts", "Title" => "First", "Author" => "Adam")
    end

    it "returns false when the header is wrong and the value is correct" do
      html.should_not have_table_row("Posts", "Label" => "First")
    end

    it "returns false when the header is correct and the value is wrong" do
      html.should_not have_table_row("Posts", "Title" => "Third")
    end

    it "returns false when on of the pairs is wrong" do
      html.should_not have_table_row("Posts", "Title" => "First", "Author" => "David")
    end

    it "returns false when given the value of another column" do
      html.should_not have_table_row("Posts", "Title" => "Adam")
    end
  end

  describe "#have_attribute" do
    let(:html) do
      Capybara.string(%Q{<div class="show_for post" id="post_1">
        <p class="wrapper post_status"><strong class="label">Title</strong><br />First</p>
        <p class="wrapper post_status"><strong class="label">Author</strong><br />Adam</p>
      </div>})
    end

    it "returns true when the label exists with the supplied value" do
      html.should have_attribute("Title", "First")
    end

    it "returns false when the label exists with but the value is wrong" do
      html.should_not have_attribute("Title", "Wrong")
    end

    it "returns false when the label does not exist even if the value does" do
      html.should_not have_attribute("Wrong", "First")
    end
  end

  describe "#have_image" do
    let(:html) { Capybara.string(%Q{<div><img src="logo.png" alt="Logo" /></div>}) }

    it "returns true if the image exists on the page" do
      html.should have_image("Logo")
    end

    it "returns false if the image doesn't exist on the page" do
      html.should_not have_image("Avatar")
    end
  end

  describe "#have_header" do
    let(:html) { Capybara.string(%Q{<div><h1>Elabs</h1><h2>Bespoke</h2><h3>Development</h3></div>}) }

    it "returns true if given the content of a h1 tag" do
      html.should have_header("Elabs")
    end

    it "returns true if given the content of a h2 tag" do
      html.should have_header("Bespoke")
    end

    it "returns false if given the content of a h3 tag" do
      html.should_not have_header("Development")
    end

    it "returns false if the content doesn't exist on the page" do
      html.should_not have_header("Bugs")
    end
  end

  describe "#have_flash_notice" do
    let(:html) { Capybara.string(%Q{<div id="flash" class="notice">Success</div><h1>Elabs</h1>}) }

    it "returns true if given the content of the flash notice" do
      html.should have_flash_notice("Success")
    end

    it "returns false if given content outside the flash notice" do
      html.should_not have_flash_notice("Elabs")
    end

    it "returns false if the content doesn't exist on the page" do
      html.should_not have_flash_notice("Failure")
    end
  end

  describe "#have_flash_alert" do
    let(:html) { Capybara.string(%Q{<div id="flash" class="alert">Error</div><h1>Elabs</h1>}) }

    it "returns true if given the content of the flash alert" do
      html.should have_flash_alert("Error")
    end

    it "returns false if given content outside the flash alert" do
      html.should_not have_flash_alert("Elabs")
    end

    it "returns false if the content doesn't exist on the page" do
      html.should_not have_flash_alert("Success")
    end
  end

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

    it "returns true with several fields if both labels and values are correct" do
      html.should have_fields("Author" => "Adam", "Year" => "2011")
    end

    it "returns true with one field if both labels and values are correct" do
      html.should have_fields("Year" => "2011")
    end

    it "returns false if the label is correct but the value is not" do
      html.should_not have_fields("Author" => "David")
    end

    it "returns false if the label is correct but the value is not" do
      html.should_not have_fields("Wrong" => "Adam")
    end

    it "returns false if the one of the pairs is incorrect" do
      html.should_not have_fields("Author" => "Adam", "Year" => "2012")
    end
  end
end
