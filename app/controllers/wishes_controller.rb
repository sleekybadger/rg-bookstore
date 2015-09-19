class WishesController < ApplicationController
  before_filter :authenticate_user!

  load_resource :book, only: :create
  load_and_authorize_resource through: :current_user, only: :create

  load_and_authorize_resource only: :destroy

  load_resource :user, only: :index
  load_and_authorize_resource through: :user, only: :index

  def create
    @wish.book = @book

    respond_to do |format|
      if @wish.save
        format.html { redirect_to book_path(@book), notice: t('wishes.added') }
      else
        format.html { redirect_to book_path(@book), alert: 'Not added' }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @wish.destroy
        format.html { redirect_to_back_or_root(notice: t('wishes.removed')) }
      else
        format.html { redirect_to_back_or_root(alert: 'Not added') }
      end
    end
  end

  def index
  end
end