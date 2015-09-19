class ReviewsController < ApplicationController
  before_filter :authenticate_user!, except: :index

  load_resource :book
  before_filter :authorize_book!, except: :index

  def new
    @review = Review.new
  end

  def index
    @reviews = @book.reviews.approved.page(params[:page])
  end

  def create
    @review = Review.new(review_params) do | review |
      review.book = @book
      review.user = current_user
    end

    respond_to do |format|
      if @review.save
        format.html { redirect_to @book, notice: t('review.created') }
      else
        format.html { render :new }
      end
    end
  end

  private

  def review_params
    params.require(:review).permit(:note, :rating)
  end

  def authorize_book!
    authorize! :add_review_to_book, @book
  end
end
