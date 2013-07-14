class PerformersController < ApplicationController
  def index
    @performers = Performer.search(params)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @performers }
    end
  end
end
