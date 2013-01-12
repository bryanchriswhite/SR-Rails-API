require 'spec_helper'

describe V1::ChallengesController do

  describe "GET #random" do
    before :each do

    end

    it "should create a session" do
      pending
      session[:challenge_id].blank?.should_not be true
    end
    it "should return a random challenge" do
      challenges = FactoryGirl.create_list :challenge, 20
      random_challenge_ids = []
      (1..3).each do |count|
        get :challenge

        current_id = assigns(:challenge).id

        if random_challenge_ids.find(current_id)
          fail
        end

        random_challenge_ids << current_id
      end
    end
  end

  describe "POST #check" do
    it "should require that a session exist" do
      session[:challenge_id].blank?.should_not be true
    end

    it "should accept a response" do
      pending
    end

  end
end
