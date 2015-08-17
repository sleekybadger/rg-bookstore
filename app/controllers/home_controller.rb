class HomeController < ApplicationController
  def index
    @best_sellers = Book.best_sellers
  end
end
