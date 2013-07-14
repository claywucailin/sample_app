class User < ActiveRecord::Base
  rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :tel, :address

  has_one :address, :as => :addressable
  has_one :avatar, :as => :imageable, :class_name => "Avatar", :dependent => :destroy

  has_many :buyer_orders, :class_name => "Order", :foreign_key => "buyer_id"
  has_many :seller_orders, :class_name => "Order", :foreign_key => "seller_id"
  has_many :listings, :class_name => "Listing", :foreign_key => "seller_id"

end
