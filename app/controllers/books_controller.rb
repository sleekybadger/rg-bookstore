class BooksController < ApplicationController
  load_and_authorize_resource

  def index
    @books = Book.page(params[:page])
    @categories = Category.all
  end

  def show
    @order_item = OrderItem.new
  end
end
