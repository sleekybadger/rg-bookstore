class Settings::HistoriesController < ApplicationController

  before_action :authenticate_user!

  def in_queue
    @orders = Order.in_queue.page(params[:page])
  end

  def in_delivery
    @orders = Order.in_delivery.page(params[:page])
  end

  def delivered
    @orders = Order.delivered.page(params[:page])
  end

  def canceled
    @orders = Order.canceled.page(params[:page])
  end

end