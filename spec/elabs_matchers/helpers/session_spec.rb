require 'spec_helper'

describe ElabsMatchers::Helpers::Session do
  let(:user) { "I'm a user record" }

  describe "#sign_in_as" do
    it "set $signed_in to true" do
      sign_in_as
      $signed_in.should be_true
    end

    it "uses sign_in as an alias" do
      sign_in
      $signed_in.should be_true
    end

    it "set current user to the given argument if any" do
      sign_in_as(user)
      current_user.should == user
    end

    it "set's the current user to nil if none given" do
      sign_in_as
      current_user.should be_nil
    end
  end

  describe "#sign_out" do
    it "sets $signed_in to nil" do
      sign_in
      sign_out
      $signed_in.should be_false
    end
  end
end
