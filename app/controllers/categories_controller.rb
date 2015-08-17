class CategoriesController < ApplicationController
  load_and_authorize_resource

  def show
    @categories = Category.all
    @books = Book.where(category: @category).page(params[:page])
  end
end
