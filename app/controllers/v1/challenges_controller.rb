class V1::ChallengesController < ApplicationController
  def random
    session[:challenge_id] = 1000
  end
end
