class Category < MasterData
  attr_accessible :description, :name, :parent_id

  belongs_to :parent, :class_name => "Category", :inverse_of => :sub_categories, :foreign_key => "parent_id"
  has_many :sub_categories, :class_name => "Category", :inverse_of => :parent, :foreign_key => "parent_id"
  has_many :events, :class_name => "Event"

  acts_as_taggable_on :tags

  def all_events
    if sub_categories.nil?
      events
    else
      events = []
      sub_categories.each do |s|
        events << s.all_events
      end
    end
  end

  def self.leaves
    all_cat = Category.all
    cat = []
    all_cat.each do |c|
      if c.sub_categories.nil?
        cat << c
      end
    end
    cat
  end

end
