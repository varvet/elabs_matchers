require "spec_helper"

describe ElabsMatchers::Matchers::HaveTableRow, :type => :feature do
  describe "#have_table_row" do
    let(:header) { %Q{
      <caption>Posts</caption>
      <thead>
        <tr><th>Title</th><th>Author</th></tr>
      </thead>} }
    subject { Capybara.string("<table>" + header + "<tbody>" + html + "</tbody></table>") }

    shared_examples "a table row matcher" do
      it "returns true when the one of the pairs in the row exists" do
        should have_table_row("Posts", "Title" => "First")
        expect { should have_table_row("Posts", "Foo" => "First") }.to fail_assertion
      end

      it "returns true when the all of the pairs in the row exists" do
        should have_table_row("Posts", "Title" => "First", "Author" => "Adam")
        expect { should have_table_row("Posts", "Title" => "First", "Author" => "Second") }.to fail_assertion
      end

      it "returns false when the header is wrong and the value is correct" do
        should_not have_table_row("Posts", "Label" => "First")
        expect { should_not have_table_row("Posts", "Title" => "First") }.to fail_assertion
      end

      it "returns false when the header is correct and the value is wrong" do
        should_not have_table_row("Posts", "Title" => "Forth")
        expect { should have_table_row("Posts", "Author" => "First") }.to fail_assertion
      end

      it "returns false when on of the pairs is wrong" do
        should_not have_table_row("Posts", "Title" => "First", "Author" => "David")
        expect { should have_table_row("Posts", "Title" => "First", "Author" => "David") }.to fail_assertion
      end

      it "returns false when given the value of another column" do
        should_not have_table_row("Posts", "Title" => "Adam")
        expect { should have_table_row("Posts", "Title" => "Adam") }.to fail_assertion
      end

      it "returns true when asking for existing blank value" do
        should have_table_row("Posts", "Author" => "")
        expect { should have_table_row("Posts", "Third" => "not empty") }.to fail_assertion
      end

      it "returns false when asking for non-existing blank value" do
        should_not have_table_row("Posts", "Title" => "")
        expect { should have_table_row("Posts", "Title" => "") }.to fail_assertion
      end

      it "returns false if there is no matching table" do
        should_not have_table_row("Other", "Title" => "First")
        expect { should_not have_table_row("Posts", "Title" => "First") }.to fail_assertion
      end
    end

    context "with text node values" do
      it_behaves_like "a table row matcher" do
        let(:html) { %Q{
          <tr><td>First</td><td>Adam</td></tr>
          <tr><td>Second</td><td>David</td></tr>
          <tr><td>Third</td><td></td></tr>}
        }
      end
    end

    context "with input field values" do
      it_behaves_like "a table row matcher" do
        let(:html) { %Q{
          <tr>
            <td><input type="text" value="First" /></td>
            <td><input type="text" value="Adam" /></td>
          </tr>
          <tr>
            <td><input type="text" value="Second" /></td>
            <td><input type="text" value="David" /></td>
          </tr>
          <tr>
            <td><input type="text" value="Third" /></td>
            <td><input type="text" value="" /></td>
          </tr>}
        }
      end
    end
  end
end
