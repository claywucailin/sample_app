class ApiEventsController < ApplicationController
  def index
    @events = Event.search(params)
    respond_to do |format|
      format.json { render json: @events.map(&:to_api_hash)}
    end
  end
end
