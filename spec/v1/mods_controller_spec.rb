require 'spec_helper'

describe "/v1/mods" do
  describe "incomplete" do
    let(:url) { "v1/mods/incomplete/10" }

    it "returns 10 mods" do
      get "#{url}.json"
      last_response.status.should eql(200)
      JSON.parse(last_response.body).length.should eq 10
    end
  end
end
