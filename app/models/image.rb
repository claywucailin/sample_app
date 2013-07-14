class Image < ActiveRecord::Base
  attr_accessible :description, :imageable_id, :imageable_type, :type
end
