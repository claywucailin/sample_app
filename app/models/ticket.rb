class Ticket < ActiveRecord::Base
  attr_accessible :event_id, :listing_id, :row, :seat, :section, :list_price, :status, :seller_id, :buyer_id

  STATUS_TYPE = {
    on_sale:   { description: I18n.t('activerecord.attributes.tickets.STATUS_TYPE.on_sale'),  weight: 1 << 0},
    ordered:   { description: I18n.t('activerecord.attributes.tickets.STATUS_TYPE.ordered'),  weight: 1 << 1},
    valid:     { description: I18n.t('activerecord.attributes.tickets.STATUS_TYPE.valid'),    weight: 1 << 2},
    canceled:  { description: I18n.t('activerecord.attributes.tickets.STATUS_TYPE.canceled'), weight: 1 << 3},
    dealed:    { description: I18n.t('activerecord.attributes.tickets.STATUS_TYPE.dealed'),   weight: 1 << 4}
  }

  belongs_to :event, :class_name => "Event", :foreign_key => "event_id"
  belongs_to :listing, :class_name => "Listing", :foreign_key => "listing_id"
  belongs_to :seller, :class_name => "User", :foreign_key => "seller_id"
  belongs_to :buyer, :class_name => "User", :foreign_key => "buyer_id"

  scope :search, lambda{|params={}|
    tickets = scoped

    tickets = tickets.where(event_id: params[:event_id]) if params[:event_id].present?
    tickets = tickets.where(listing_id: params[:listing_id]) if params[:listing_id].present?
    tickets = tickets.where{status.in params[:status]} if params[:status].present?
    tickets = tickets.where(section: params[:section]) if params[:section].present?
    tickets = tickets.where(seller_id: params[:seller_id]) if params[:seller_id].present?
    tickets = tickets.where(buyer_id: params[:buyer_id]) if params[:buyer_id].present?

    tickets
  }

  scope :unsold, lambda{ where{status == STATUS_TYPE[:on_sale][:weight]} }
  scope :sold, lambda{ where{status.in(STATUS_TYPE.reject{|key,value| key == :on_sale}.map{|key,value| value[:weight]})} }

end
