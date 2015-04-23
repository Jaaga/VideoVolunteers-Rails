class SearchController < ApplicationController
  def index
  	if params[:search].present?
      search = Tracker.search do
        fulltext params[:search] do
        	query_phrase_slop 1
        	minimum_match 1
      	end
      	paginate page: params[:page], per_page: 20
      end
      @trackers = search.results
    else
      @trackers = []
    end
  end
end
