require 'spec_helper'

describe ElabsMatchers::Helpers::Fixtures do
  describe "#fixture_file" do
    it "opens the file from the fixtures file" do
      fixture_file("file.txt").read.should == "My file content."
    end
  end
end