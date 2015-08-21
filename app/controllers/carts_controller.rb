class CartsController < ApplicationController
  def show
  end

  def complete
    unless flash[:order_id]
      not_found
    end

    @order = Order.find(flash[:order_id])
  end
end