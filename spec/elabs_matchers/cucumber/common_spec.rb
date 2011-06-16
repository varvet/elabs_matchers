require 'spec_helper'

describe ElabsMatchers::Cucumber::Common do
  describe "LIST_SEPARATOR" do
    it "matches ," do
      ", ".should =~ Cucumber::LIST_SEPARATOR
    end

    it "matches and" do
      " and ".should =~ Cucumber::LIST_SEPARATOR
    end

    it "doesn't matches other things" do
      "foo".should_not =~ Cucumber::LIST_SEPARATOR
    end
  end

  describe "LIST_REGEXP" do
    it "matches just one item" do
      %Q{"Bart"}.should =~ Cucumber::LIST_REGEXP
    end

    it "matches a comma seperated list" do
      %Q{"Bart", "Lisa"}.should =~ Cucumber::LIST_REGEXP
    end

    it "matches a 'and' seperated list" do
      %Q{"Bart" and "Lisa"}.should =~ Cucumber::LIST_REGEXP
    end

    it "matches a comma and 'and' seperated list" do
      %Q{"Bart", "Lisa" and "Homer"}.should =~ Cucumber::LIST_REGEXP
    end

    it "matches a comma and 'and' seperated list with several words" do
      %Q{"Bart Simpsons", "Lisa Simpsons" and "Homer Simpsons"}.should =~ Cucumber::LIST_REGEXP
    end

    it "doesn't matches other things" do
      %Q{foo}.should_not =~ Cucumber::LIST_REGEXP
    end
  end

  describe "#human_list_to_array" do
    it "converts a LIST_REGEXP-list to an array" do
      human_list_to_array(%Q{"Bart", "Lisa" and "Homer"}).should == %w[Bart Lisa Homer]
    end
  end
end
