require 'spec_helper'

describe ElabsMatchers::Capybara do
  let(:page) { Capybara::Session.new(:rack_test, proc { |env| [200, {}, [html]]}) }
  let(:html) do
    %Q{
      <label for="post_date_1i">Date</label>
      <select id="post_date_1i" name="post[date(1i)]">
        <option value='2009' selected='selected'>2009</option>
        <option value='2010'>2010</option>
      </select>
      <select id="post_date_2i" name="post[date(2i)]">
        <option value='1' selected='selected'>January</option>
        <option value='2'>February</option>
      </select>
    }
  end

  before do
    page.extend(ElabsMatchers::Capybara)
    page.visit "/"
  end

  describe "#select_year_and_month" do
    it "selects the year and momth selects" do
      page.select_year_and_month('2010', 'February', :from => "Date")

      page.find("#post_date_1i").find('option[selected]').text.should == "2010"
      page.find("#post_date_2i").find('option[selected]').text.should == "February"
    end
  end
end
