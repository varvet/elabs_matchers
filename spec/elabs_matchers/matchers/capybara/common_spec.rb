require 'spec_helper'

describe ElabsMatchers::Matchers::Capybara do
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
end