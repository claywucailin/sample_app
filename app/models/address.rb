class Address < ActiveRecord::Base
  attr_accessible :region_id, :street_address, :zipcode, :recipient, :tel

  belongs_to :addressable, :polymorphic => true
  belongs_to :region, :class_name => "Region", :foreign_key => "region_id"

end
