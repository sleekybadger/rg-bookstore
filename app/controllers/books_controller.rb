class BooksController < ApplicationController
  load_and_authorize_resource

  def index
    @books = Book.page(params[:page])
    @categories = Category.all
  end

  def show
    @wish = current_user.wishes.find_by(book: @book) if current_user
  end
end
