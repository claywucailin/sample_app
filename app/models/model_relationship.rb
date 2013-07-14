class ModelRelationship < ActiveRecord::Base
  #attr_accessible :refer_from_id, :refer_from_type, :refer_to_id, :refer_to_type
  belongs_to :refer_from, polymorphic: true
  belongs_to :refer_to,   polymorphic: true

  # http://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html
  # Using polymorphic associations in combination with single table inheritance (STI) 
#  def attachable_type=(sType)
#    super(sType.to_s.classify.constantize.base_class.to_s)
#  end

end
