class HomeController < ApplicationController
  def index
    @best_sellers = Book.best_sellers.to_a
  end

  def search
    @query = params[:query]
    @search_by = params[:search_by]
    @results = Search.new(@query, @search_by).search.results
  end
end
