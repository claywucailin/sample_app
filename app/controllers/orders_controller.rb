class OrdersController < ApplicationController
  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @order = Order.new(params[:order])
    listing = Listing.find(params[:listing_id])
    event = Event.find(params[:event_id])
    addr = Address.find_or_create_by_street_address( params[:address][:street_address])

    addr.update_attributes(params[:address])

    order_attributes = {
      shipment_method: params[:shipment_method],
      payment_date: Time.now(),
      payment_method: 0, #TODO
      shipment_date: Time.now(),
      status: 0, #TODO
      shipment_fee: 0,
      service_fee: 0,
      total_amount: params[:tickets_amount].to_i * listing.list_price,
      tickets_amount: params[:tickets_amount].to_i
    }

    @order.update_attributes(order_attributes)

    @order.seller = listing.seller
    @order.buyer = current_user
    @order.shipment_address = addr

    # get tickets
    tickets = listing.get_some_available_tickets params[:tickets_amount].to_i

    listing.tickets.each do |t|
      @order.items.build({
        selling_price: 0,
        ticket_id: t.id
      })
    end

    respond_to do |format|
      if @order.save
        #format.html { redirect_to @order, notice: 'Order was successfully created.' }
        format.html { redirect_to success_order_url(@order) }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id])

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end

  def checkout
    if current_user.nil?
      redirect_to root_url, notice: 'Please log in'
    else
      @order = Order.new
      @event = Event.find(params[:event_id])
      @listing = Listing.find(params[:listing_id])
    end

  end

  def success
    @order = Order.find(params[:id])
  end
end
