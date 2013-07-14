class Venue < ActiveRecord::Base
  attr_accessible :description, :name

  has_one :address, :as => :addressable

  has_many :photos, :class_name => "VenuePhoto", :as => :imageable, :dependent => :destroy
  has_many :venue_section_relationships, class_name: "ModelRelationship", as: :refer_from, dependent: :destroy
  has_many :sections, through: :venue_section_relationships, source: :refer_to, source_type: "VenueSection"

  def to_api_hash
    {
      id: id,
      name: name,
      description: description,
      address: address.street_address
    }
  end
end
