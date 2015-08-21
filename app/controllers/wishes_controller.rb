class WishesController < ApplicationController

  before_filter :authenticate_user!

  before_action :set_user

  authorize_resource :user

  def create
    @book = Book.find(params[:book_id])

    redirect_params = {}

    if @user.wishes.exists? @book
      redirect_params[:alert] = t('wishes.already_added', book: @book)
    else
      @user.wishes << @book

      redirect_params[:notice] = t('wishes.added', book: @book)
    end

    respond_to do |format|
      format.html { redirect_to user_wishes_path(@user), redirect_params }
    end
  end

  def destroy
    @book = Book.find(params[:book_id])

    redirect_params = {}

    if @user.wishes.exists? @book
      @user.wishes.delete @book

      redirect_params[:notice] = t('wishes.removed', book: @book)
    else
      redirect_params[:alert] = t('wishes.not_exists', book: @book)
    end

    respond_to do |format|
      format.html { redirect_to user_wishes_path(@user), redirect_params }
    end
  end

  def index
  end

  private

    def set_user
      @user = params[:user_id] ? User.find(params[:user_id]) : current_user
    end

end