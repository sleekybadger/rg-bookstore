class HomeController < ApplicationController

  def index
    @best_sellers = Book.best_sellers.to_a
  end

  def search
    @query = params[:query]
    @search_by = params[:search_by]

    @results =
      case @search_by
        when 'books'
          Book.search(@query)
        when 'authors'
          Author.search(@query)
        else
          []
      end
  end

end
