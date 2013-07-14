#encoding:utf-8
class SearchResultController < ApplicationController
  def index
    @types = Category.select("id, name").where{parent_id != nil}.all
    @locations = Region.select("id, name").all
    @prices = [ ["全部",          ""], 
                ["￥100~￥200",   "100_200"], 
                ["￥200～￥300",  "200_300"], 
                [">￥300",        "300_"] 
    ]
    @headers={"headers"=>[{"value"=>"比赛","name"=>"game"},{"value"=>"时间","name"=>"time"},{"value"=>"地点","name"=>"location"},{"value"=>"细节","name"=>"detail"}]}
    @games = {"games"=>[{"value"=>"全部"},{"value"=>"比赛1"},{"value"=>"比赛2"},{"value"=>"比赛3"}]}
    
    search_params = collect_params
    search_params = sanitize_params(search_params)

    # TODO strange problem: by default, search user's location, but what if the region on the page is sellected ?
    @regional_events = Event.search(search_params)
    @total_regional_events_count = @regional_events.count
    @most_recent_regional_event = @regional_events.most_recent(1).first
    @regional_events = @regional_events.recent_first.page(params[:page]).per_page(5)
    regional_event_ids = @regional_events.select{id}
    @other_regional_events = Event.search(title: search_params[:title]).where{id.not_in regional_event_ids}
    #@total_other_regional_events_count = @other_regional_events.count
    #@most_recent_other_regional_event = @other_regional_events.most_recent(1).first
    @other_regional_events = @other_regional_events.recent_first.page(params[:page]).per_page(5)
  end

  private
  def search_keys
    ['region_id', 'search', 'category_id', 'price_range']
  end

  def collect_params
    params.inject({}) do |acc, item| 
      if search_keys.include?(item.first) 
        acc[item.first.to_sym] = item.last
      end
      acc
    end
  end

  def sanitize_params(search_params={})
    if search_params.key?(:price_range)
      search_params[:list_price] = {}
      search_params[:list_price][:start], search_params[:list_price][:end] = search_params[:price_range].split("_").map(&:to_i) 
    end
    if search_params[:search]
      search_params[:title] = search_params[:search]
      search_params.delete(:search)
    end
    unless search_params[:region_id]
      search_params[:region_id] = current_region
    end
    search_params
  end
end
