class SearchController < ApplicationController
  def index
  	if params[:search].present?
      search = Tracker.search_any_word(params[:search]).page(params[:page]).per_page(20)
      @trackers = search
    else
      @trackers = []
    end
  end
end
