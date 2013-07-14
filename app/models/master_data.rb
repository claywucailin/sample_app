class MasterData < ActiveRecord::Base
  attr_accessible :description, :name, :type, :parent_id
end
