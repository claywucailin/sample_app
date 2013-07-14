#encoding: utf-8
class Order < ActiveRecord::Base
  attr_accessible :buyer_id, :payment_date, :payment_method, :shipment_date, :shipment_method, :total_amount, :status, :shipment_fee, :service_fee, :tickets_amount, :seller_id

  belongs_to :buyer, :class_name => "User", :foreign_key => "buyer_id"
  belongs_to :seller, :class_name => "User", :foreign_key => "seller_id"

  has_one :shipment_address, :class_name => "Address", :as => :addressable, :dependent => :destroy

  has_many :items, :class_name => "OrderItem", :dependent => :destroy
  has_many :tickets, :through => :items

  PAYMENT_TYPE = [['boc', '中国银行'],['icbc', '中国工商银行'], ['cmb', '招商银行'], \
                  ['ccb', '中国建设银行'],['abc', '中国农业银行'], ['post', '中国邮政']]

end
