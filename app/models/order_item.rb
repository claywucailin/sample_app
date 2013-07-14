class OrderItem < ActiveRecord::Base
  attr_accessible :order_id, :selling_price, :ticket_id, :receipt_date

  belongs_to :order, :class_name => "Order", :foreign_key => "order_id"
  belongs_to :ticket, :class_name => "Ticket", :foreign_key => "ticket_id"

end
