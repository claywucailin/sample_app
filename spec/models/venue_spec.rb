require 'spec_helper'

describe Venue do
  describe "#to_api_hash" do
    let(:category) { FactoryGirl.create(:category, name: "sport") }
    let(:region)   { FactoryGirl.create(:region, name: "guangzhou") }
    let(:address)  { FactoryGirl.create(:address, street_address: "tianhe, guangzhou", zipcode: "510000", region_id: region.id)}

    context "when venue is a new record" do
      subject { FactoryGirl.build(:venue, name: "tianhe sport center", description: "tianhe dist.", address: address) }

      it "should return a hash with id is null" do
        subject.to_api_hash.should == {id: nil, name: "tianhe sport center", description: "tianhe dist.", address: "tianhe, guangzhou"}
      end
    end

    context "when venue is a saved record" do
      subject { FactoryGirl.create(:venue, name: "tianhe sport center", description: "tianhe dist.", address: address) }


      it "should return a hash with descent hash" do
        subject.to_api_hash.should == { id: subject.id,
                                        name: "tianhe sport center", 
                                        description: "tianhe dist.",
                                        address: "tianhe, guangzhou"
                                      }
      end

    end

  end
end
