class Listing < ActiveRecord::Base
  attr_accessible :event_id, :seller_id, :split_type, :status, :tickets_count, :section, :row, :seat_type, :split_divisor, :list_price, :tickets_attributes

  (1..10).map{|num| "seat_no_#{num}"}.each do |input|
    attr_accessor   input
    attr_accessible input
  end

  SHIPMENT_METHOD = [[ I18n.t('.listings.show.ship'), 1], [I18n.t('.listings.show.self'), 2]]

  SPLIT_TYPE = {
    no_orphan:   { description: I18n.t('activerecord.attributes.listings.SPLIT_TYPE.no_orphan'),
                   weight:      1 << 0},
    split_with:  { description: I18n.t('activerecord.attributes.listings.SPLIT_TYPE.split_with'),
                   weight:      1 << 1},
    no_split:    { description: I18n.t('activerecord.attributes.listings.SPLIT_TYPE.no_split'),
                   weight:      1 << 2}
  }

  SEAT_TYPE = {
    with_seat_details:      { description: I18n.t('activerecord.attributes.listings.SEAT_TYPE.with_seat_details'),
                              weight:      1 << 0},
    with_out_seat_details:  { description: I18n.t('activerecord.attributes.listings.SEAT_TYPE.with_out_seat_details'),
                              weight:      1 << 1}
  }

  STATUS_TYPE = {
    on_sale: { description: I18n.t('activerecord.attributes.listings.STATUS_TYPE.on_sale'), weight: 1},
    dealed: { description: I18n.t('activerecord.attributes.listings.STATUS_TYPE.dealed'), weight: 2}
  }

  COMMISSION_RATE = 0.075

  belongs_to :event, :class_name => "Event", :foreign_key => "event_id"
  belongs_to :seller, :class_name => "User", :foreign_key => "seller_id"

  has_many :tickets, :class_name => "Ticket", :dependent => :destroy
  accepts_nested_attributes_for :tickets#, reject_if: lambda{ |a| a[:seat].blank? }, allow_destroy: true

  validates :event_id, presence: true, if: :info_step?
  validates :seller_id, presence: true, if: :info_step?
  validates :seat_type, presence: true, if: :info_step?
  validates :split_type, presence: true, if: :info_step?
  validates :tickets_count, presence: true, if: :info_step?
  validates :section, presence: true, if: :info_step?
  validates :row, presence: true, if: :info_step?
  validates :list_price, presence: true, if: :pricing_step?
  validate  :validate_tickets_with_seat_details, if: :on_info_step_and_with_seat_details?

  scope :search, lambda{|params={}|
    listings = scoped
    listings = listings.where{seat_type == params[:seat_type]} if params[:seat_type].present?
    listings = listings.where{section == params[:section]} if params[:section].present?
    listings = listings.where{event_id == params[:event_id]} if params[:event_id].present?
    listings = listings.where{row == params[:row]} if params[:row].present?

    listings
  }

  scope :fields_on_selling_page, lambda{ includes{event}.select("listings.list_price, listings.row, listings.tickets_count, events.start_time") }

  scope :latest_first, lambda{ order("listings.created_at DESC") }
  scope :sold, lambda{ joins{tickets}.where{tickets.status != Ticket::STATUS_TYPE[:on_sale][:weight] }.group("listings.id") }
  scope :unsold, lambda{ joins{tickets}.where{tickets.status == Ticket::STATUS_TYPE[:on_sale][:weight] }.group("listings.id") }

  def self.split_type_list
    SPLIT_TYPE.map{|key,value| [value[:description], value[:weight]]}
  end

  def self.seat_type_list
    SEAT_TYPE.map{|key,value| [value[:description], value[:weight]]}
  end

  def self.calculate_net_price(lprice = 0)
    if lprice.is_a?(Numeric) && lprice > 0
      lprice - (lprice * COMMISSION_RATE).round(2)
    else
      0
    end
  end

  def create_for_sell(listing)

  end

  def add_ticket ticket
    if self.tickets_count == 0 # first ticket
      self.tickets_count = 1
      self.total_amount = ticket.list_price
    else
      self.tickets_count = self.tickets_count + 1
      self.total_amount = self.total_amount + ticket.list_price
    end
    ticket.section = section
    ticket.row = row
    ticket.seller = seller
    tickets << ticket
    self.save!
  end

  def sold_average_price
    sold_tickets.map(&:list_price).inject(&:+) || 0
  end

  def unsold_average_price
    unsold_tickets.map(&:list_price).inject(&:+) || 0
  end

  def sold_tickets
    tickets.select{|ticket| Ticket::STATUS_TYPE.reject{|key,value| key == :on_sale}.map{|key,value| value[:weight]}.include?(ticket.status) }
  end

  def unsold_tickets
    tickets.select{|ticket| ticket.status == Ticket::STATUS_TYPE[:on_sale][:weight]}
  end

  def update_price
    if list_price && list_price > 0
      self.net_price = self.class.calculate_net_price(self.list_price)
      self.commission = self.list_price - self.net_price
    end
  end

  def list_price=(value)
    super
    update_price
  end

  attr_writer :current_step
  CREATE_STEPS = %w[info pricing payment]
  CREATE_STEPS.each do |step|
    __send__(:define_method, "#{step}_step?"){ current_step == step }
  end
  def steps
    CREATE_STEPS
  end
  def current_step
    @current_step || steps.first
  end
  def first_step?
    @current_step == steps.first
  end
  def last_step?
    @current_step == steps.last
  end
  def all_valid?
    steps.all? do |step|
      self.current_step = step
      valid?
    end
  end
  def next_step
    self.current_step = steps[steps.index(current_step)+1]
  end
  def previous_step
    self.current_step = steps[steps.index(current_step)-1]
  end

  def on_sale?
    status == STATUS_TYPE[:on_sale][:weight]
  end

  def get_some_available_tickets number
    if number > 0
      self.unsold_tickets[0..number-1]
    else
      []
    end
  end

  private

  def on_info_step_and_with_seat_details?
    info_step? && SEAT_TYPE[:with_out_seat_details][:weight] == seat_type
  end

  def validate_tickets_with_seat_details
    if SEAT_TYPE[:with_seat_details][:weight] == seat_type
      unless tickets.select{|ticket| !ticket.seat.blank? }.size == tickets_count
        errors.add(:seat_type, I18n.t("activerecord.errors.models.listing.tickets_count_not_equals_to_seats_count"))
      end
    end
  end
end
