class PaymentMethod < ActiveRecord::Base
  attr_accessible :agreement_confirmed, :info_confirmed, :payment_details, :payment_type, :billing_address_attributes, :billing_address

  serialize :payment_details

  PAYMENT_TYPE = { uionpay: { weight: 1 << 0, billing_method: "" }, 
                   alipay:  { weight: 1 << 1, billing_method: "" }
  }

  belongs_to :payable, polymorphic: true

  has_one :billing_address, as: :addressable, class_name: "Address", dependent: :destroy
  accepts_nested_attributes_for :billing_address
  
  validates :agreement_confirmed, confirmation: true
  validates :info_confirmed, confirmation: true
  validates :payment_type, presence: true



end
