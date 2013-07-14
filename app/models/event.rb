class Event < ActiveRecord::Base
  attr_accessible :description, :region_id, :venue_id, :category_id, :listing_count, :start_time, :end_time, :title

  belongs_to :venue, :class_name => "Venue"
  belongs_to :category, :class_name => "Category"
  belongs_to :region, :class_name => "Region"

  has_many :listings, :class_name => "Listing", :dependent => :destroy
  has_many :tickets, :class_name => "Ticket", :through => :listings
  has_many :performer_relationships, class_name: "ModelRelationship", as: :refer_from, dependent: :destroy
  has_many :performers, through: :performer_relationships, source: :refer_to, source_type: "Performer"

  has_one :poster, :class_name => "EventPoster", :as => :imageable, :dependent => :destroy

  acts_as_taggable

  validates :description, :presence => true
  validates :title, :presence => true
  validates :start_time, :presence => true

  scope :api, lambda{
    includes(:venue => [:address]).select("events.id,events.start_time,events.end_time,events.description,events.title,venues.description,venues.name,venues.id,addresses.id,addresses.street_address")
  }

  default_scope order("events.start_time DESC")

  scope :performer_initial_in, lambda {|initial|
    initial = Array(initial).map(&:first).map(&:upcase)
    initial.empty? ? scoped : scoped.joins{performers}.where{performers.id.in(Performer.where{left(aka,1).in(initial)}.select{id})}
  }
  scope :list_price_between, lambda {|*args|
    events = scoped.joins{listings} unless args.empty?
    events = events.where{listings.list_price >= args[0]} if args[0]
    events = events.where{listings.list_price <= args[1]} if args[1]
    events
  }

  scope :latest, lambda { |count=1| scoped.limit(count) }
  scope :valid, lambda{ scoped.where{ (start_time > DateTime.now) }}
  scope :most_recent, lambda{ |count=1| recent_first.limit(count) }
  scope :recent_first, lambda{ valid.reorder(nil).order("events.start_time") }

  scope :search, lambda {|params = {}|
    events = scoped
    events = events.tagged_with("#{params[:tags]}", any: true) if params[:tags].present?
    events = events.where("id = ?", "#{params[:id]}") if params[:id].present?
    events = events.where("venue_id = ?", "#{params[:venue_id]}") if params[:venue_id].present?
    events = events.where("region_id = ?", "#{params[:region_id]}") if params[:region_id].present?
    events = events.where("region_id != ?", "#{params[:not_region_id]}") if params[:not_region_id].present?
    events = events.where("title like ?", "%#{params[:title]}%") if params[:title].present?
    events = events.where("start_time >= ?", "#{params[:start_time]}") if params[:start_time].present?
    events = events.where("start_time <= ?", "#{params[:end_time]}") if params[:end_time].present?
    events = events.where("type = ?", "#{params[:type]}") if params[:type].present?
    events = events.list_price_between(params[:list_price][:start], params[:list_price][:end]) if params[:list_price]
    events = events.performer_initial_in((params[:init_start]..params[:init_end]).to_a.map(&:upcase)) if ([params[:init_start],params[:init_end]].map{|a| a.try(:upcase)} - ("A".."Z").to_a).empty?
    events = events.joins{performers}.where{performers.id.in(params[:performer_id])} if params[:performer_id].present?

    if params[:category_id].present?
      category = Category.find(params[:category_id])
      if category.sub_categories.empty?
        category_ids = [params[:category_id]]
      else
        category_ids = category.sub_category_ids
      end
      events = events.where(:category_id => category_ids)
    end

    events
  }

  def self.method_missing(id,*args,&block)
    # catch class_methods like Event.performer_initial_between_A_and_E
    return __send__("performer_initial_in", ($1..$2).to_a.map(&:upcase)) if id.to_s =~ /performer_initial_between_([A-Za-z])_and_([A-Za-z])/
    super
  end

  def to_api_hash
    {
      id: id,
      start_time: start_time.try(:iso8601),
      end_time: end_time.try(:iso8601),
      description: description,
      title: title,
      venue: venue.try(:to_api_hash)
    }
  end

end
