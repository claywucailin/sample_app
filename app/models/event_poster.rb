class EventPoster < Image
  attr_accessible :data
  belongs_to :imageable, :polymorphic => true
  has_attached_file :data, :styles => { :medium => "960x600>", :thumb => "160x100>" }, :default_url => "/images/:style/missing.png"
end
