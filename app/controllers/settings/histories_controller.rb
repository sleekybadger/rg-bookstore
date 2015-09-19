class Settings::HistoriesController < ApplicationController
  before_action :authenticate_user!

  def in_queue
    @orders = current_user.orders.in_queue.page(params[:page])
  end

  def in_delivery
    @orders = current_user.orders.in_delivery.page(params[:page])
  end

  def delivered
    @orders = current_user.orders.delivered.page(params[:page])
  end

  def canceled
    @orders = current_user.orders.canceled.page(params[:page])
  end
end