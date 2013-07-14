class PerformerPoster < Image
  attr_accessible :data
  belongs_to :imageable, :polymorphic => true
  has_attached_file :data, :styles => { :medium => "300x300>", :thumb => "100x100" }, :default_url => "/images/:style/missing.png"
end
