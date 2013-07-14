class Region < MasterData
  attr_accessible :description, :name

  acts_as_taggable_on :tags

  has_one :parent, :class_name => "Region", :foreign_key => "parent_id"
  has_many :events, class_name: "Event", foreign_key: "region_id"


  scope :order_by_events_count, lambda {
    unscoped.joins{events}.select("master_data.id,master_data.name,count(events.id) as events_count").group("master_data.id").order("count(events.id) desc")
    #.select("regions.id,regions.name,count(events.id) as events_count").order("events_count desc")
  }
end
