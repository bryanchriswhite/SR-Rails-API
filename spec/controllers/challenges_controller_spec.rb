require 'spec_helper'

describe ChallengesController do

  describe "#random" do
    before :each do

    end

    it "should create a session" do
      session[:challenge_id].should_not be blank?
    end
    it "should return a random challenge" do
      pending
    end
  end

  describe "#check" do
    it "should require that a session exist" do
      session[:challenge_id].should_not be blank?
    end

    it "should accept a response" do
      pending
    end

  end
end
