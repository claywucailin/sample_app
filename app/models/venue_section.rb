class VenueSection < MasterData
  attr_accessible :description, :name

  has_one :venue_section_relationship, class_name: "ModelRelationship", as: :refer_to, dependent: :destroy
  has_one :venue, through: :venue_section_relationship, source: :refer_from, source_type: "Venue"

end
