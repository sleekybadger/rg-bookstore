class AuthorsController < ApplicationController
  load_and_authorize_resource

  def index
    @authors = Author.page(params[:page])
  end

  def show
  end
end