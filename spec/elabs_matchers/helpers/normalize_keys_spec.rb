require "spec_helper"

describe ElabsMatchers::Helpers::NormalizeKeys do
  describe "normalize_keys" do
    it "turns the keys into symbols" do
      normalize_keys("First name" => "Adam").keys.first.should == "first_name"
    end

    it "turns paramaterizes the key with _ as seperator" do
      normalize_keys("First name" => "Adam").keys.first.should == "first_name"
    end

    it "doesn't change the values" do
      normalize_keys("First name" => "Adam").values.first.should == "Adam"
    end

    it "turns the hash into a HashWithIndifferentAccess" do
      normalize_keys("First name" => "Adam").class.should == HashWithIndifferentAccess
    end

    it "works with several pairs" do
      normalize_keys("First name" => "Douglas", "Last name" => "Adams").should == { "first_name" => "Douglas", "last_name" => "Adams" }
    end
  end
end
