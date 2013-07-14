require 'spec_helper'

describe Event do

  context "#search" do

    context "by tags" do
      it "returns an array of results that has given tags" do
        # default tag is 'music'
        country = FactoryGirl.create(:event)
        pop = FactoryGirl.create(:event)

        football = FactoryGirl.create(:event)
        football.tag_list = "sports"
        football.save

        Event.search({tags: "music"}).should == [country, pop]
        Event.search({tags: "music, sports"}).should == [country, pop, football]
      end
    end

    context "by category" do
      it "returns an array of results that match given category" do
        c1 = FactoryGirl.create(:category)
        c2 = FactoryGirl.create(:category, parent_id: c1.id)
        c3 = FactoryGirl.create(:category, parent_id: c1.id)

        country = FactoryGirl.create(:event, category_id: c2.id)
        pop = FactoryGirl.create(:event, category_id: c3.id)

        Event.search({category_id: c1.id}).should == [country, pop]
        Event.search({category_id: c2.id}).should == [country]
      end
    end

    context "by region" do
      it "returns an array of results that match given region" do
        country = FactoryGirl.create(:event, region_id: 1)
        pop = FactoryGirl.create(:event, region_id: 2)
        football = FactoryGirl.create(:event, region_id: 1)

        Event.search({region_id: 1}).should == [country, football]
      end
    end

    context "by venue" do
      it "returns an array of results that match given venue" do
        country = FactoryGirl.create(:event, venue_id: 1)
        pop = FactoryGirl.create(:event, venue_id: 2)
        football = FactoryGirl.create(:event, venue_id: 1)

        Event.search({venue_id: 1}).should == [country, football]
      end
    end

    context "by range of time" do
      it "returns an array of results that happen between give time" do
        country = FactoryGirl.create(:event, start_time: "2013-6-29")
        pop = FactoryGirl.create(:event, start_time: "2013-5-29")

        Event.search({start_time: "2013-6-1", end_time: "2013-7-1"})
             .should == [country]
      end
    end

  end

  describe "#to_api_hash" do
    let(:category) { FactoryGirl.create(:category, name: "sport") }
    let(:region)   { FactoryGirl.create(:region, name: "guangzhou") }
    let(:address)  { FactoryGirl.create(:address, street_address: "tianhe, guangzhou", zipcode: "510000", region_id: region.id)}
    let(:venue)    { FactoryGirl.create(:venue, name: "tianhe sport center", description: "tianhe dist.", address: address) }

    context "when event is a new record" do
      subject { FactoryGirl.build(:event, title: "test title", description: "test desc", start_time: "2013-07-01", end_time: "2013-07-10") }

      it "should return a hash with id is null" do
        subject.to_api_hash.should == {id: nil, start_time: "2013-07-01T00:00:00+08:00", end_time: "2013-07-10T00:00:00+08:00", description: "test desc", title: "test title", venue: nil}
      end
    end

    context "when event is a saved record" do
      subject { FactoryGirl.create(:event, title: "test title", description: "test desc", start_time: "2013-07-01", end_time: "2013-07-10", venue_id: venue.id) }

      it "should return a hash with descent hash" do
        venue.stub(:to_api_hash){{id: venue.id, name: venue.name, description: venue.description, address: "tianhe, guangzhou"}}
        subject.to_api_hash.should == {id: subject.id, 
                                       start_time: "2013-07-01T00:00:00+08:00", 
                                       end_time: "2013-07-10T00:00:00+08:00", 
                                       description: "test desc", 
                                       title: "test title", 
                                       venue: {
                                         id: venue.id,
                                         name: "tianhe sport center", 
                                         description: "tianhe dist.",
                                         address: "tianhe, guangzhou"
                                       } 
                                      }

      end

    end

  end
end
