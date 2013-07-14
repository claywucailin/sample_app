require 'spec_helper'

describe ApiEventsController do
  describe "GET index" do
    it "assigns @events" do
      event = FactoryGirl.create(:event)
      get :index, format: :json
      expect(assigns(:events)).to eq([event])
    end

    it "responds with JSON" do
      event = FactoryGirl.create(:event, title: "test title", description: "test desc")
      get :index, format: :json
      response.body.should == [event].map(&:to_api_hash).to_json
    end
  end
end
