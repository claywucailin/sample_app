require 'spec_helper'

describe SportTeam do
  
  describe "#new" do

    it "should have a name" do
      no_name_sport_team = FactoryGirl.build(:sport_team, name: "")
      no_name_sport_team.should have(1).error_on(:name)
    end

  end

  describe "#define_method" do
    subject{ FactoryGirl.build(:sport_team) }
#    it {should have_many(:sport_event_relationships)}
#    it {should have_many(:sport_events)}
#    it {should have_one(:poster)}
  end

end
