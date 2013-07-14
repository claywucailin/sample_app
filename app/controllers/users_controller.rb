#encoding: utf-8
class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @buyer_orders = @user.buyer_orders.paginate(:per_page => 1, :page => params[:page])

    listings = @user.listings

    unsold_items = []
    sold_items = []

    listings.each do |l|
      event = l.event
      name = event.title
      time = event.start_time.strftime("%Y.%m.%d")
      if l.on_sale?
        unsold_items << {event_name: name, time: time, price: l.unsold_tickets.first.list_price, ticket_amount: l.unsold_tickets.count, status: ["on_sale", "待售"]}
        sold_items << {event_name: name, time: time, price: l.sold_tickets.first.list_price, ticket_amount: l.sold_tickets.count, status: ["sold", "已售"] } unless l.sold_tickets.empty?
      else
        sold_items << {event_name: name, time: time, price: l.tickets.first.list_price, ticket_amount: l.tickets.count, status: ["sold", "已售"] }
      end
    end

    7.times do |i|
      name = "title" + i.to_s()
      time = "2013.02.12"
      if i%2==1
        unsold_items << {event_name: name, time: time, price: i, ticket_amount: i, status: ["on_sale", "待售"]}
      else
        sold_items << {event_name: name, time: time, price: i, ticket_amount: i, status: ["sold", "已售"] }
      end
    end

    @items = (sold_items + unsold_items).paginate(:per_page => 7, :page => params[:page])
  end
end
