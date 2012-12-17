require 'spec_helper'

describe "/v1/categorizations" do
  describe "user creates a categorization" do
    let(:url) { "v1/categorizations" }

    it "json" do
      #let(:user) { create_user! }
      #add authorization token stuff the next time
      categorization_hash = {mod_id: 1, category_id: 4, user_id: 33}
      post "#{url}.json", categorization_hash
      last_response.status.should eql(200)
      Categorization.all.any? do |c|
        c.user_id == categorization_hash[:user_id] &&
            c.category_id == categorization_hash[:category_id] &&
            c.mod_id == categorization_hash[:mod_id]
      end.should be_true
    end
  end
end