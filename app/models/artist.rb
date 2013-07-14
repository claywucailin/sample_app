class Artist < Performer
  serialize :profiles, Hash
  attr_accessible :aka, :description, :name

  validates :name, presence: true

  has_many :musical_event_relationships, class_name: "ModelRelationship", as: :refer_to, dependent: :destroy
  has_many :musical_events, through: :musical_event_relationships, source: :refer_from, source_type: "Event", conditions: { type: "MusicalEvent" }
  has_one :poster, class_name: "PerformerPoster", as: :imageable

  def self.profileable_attributes
    ["name_zh", "name_en", "date_of_birth", "blood_type", "height", "weight", "birth_place", "region", "sign"]
  end
  self.profileable_attributes.each do |attr|
    self.send(:define_method, "#{attr}="){ |value| self.profiles[attr] = value; }
    self.send(:define_method, attr){ self.profiles[attr]; }
  end

end
