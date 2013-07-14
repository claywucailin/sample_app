class SellingsController < ApplicationController
  before_filter :authenticate_user!
  #load_and_authorize_resource false

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def new
    session[:listing_params], session[:listing_step] = {}, nil
    #@listing = Listing.new(session[:listing_params])
    event = Event.search({id: params[:event_id]}).first
    @listing = current_user.listings.build(event_id: event.try(:id))
    5.times{ @listing.tickets.build }
    logger.info "tickets.count:#{@listing.tickets.count}"
    logger.info "tickets.size:#{@listing.tickets.size}"
  end

  def create
    session[:listing_params].deep_merge!(params[:listing]) if params[:listing]
    @listing = current_user.listings.build(session[:listing_params])
    @listing.current_step = session[:listing_step]
    #binding.pry
    if params[:previous_button]
      @listing.previous_step
    elsif params[:submit] && @listing.last_step? && @listing.valid?
      Listing.create_for_sell(@listing, current_user) if @listing.all_valid?
    else
      @listing.next_step
    end
    session[:listing_step] = @listing.current_step
    if @listing.new_record?
      render 'new'
    else
      session[:listing_step] = session[:listing_params] = nil
      flash[:notice] = "Listing Saved!"
      redirect_to @listing
    end
  end

end
