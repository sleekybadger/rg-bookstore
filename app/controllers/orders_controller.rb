class OrdersController < ApplicationController

  before_action :set_book_and_order_item

  def add_item
    if @order_item
      @order_item.quantity += order_item_params[:quantity].to_i
    else
      @order_item = OrderItem.new(order_item_params) do | item |
        item.order = @current_order
        item.book = @book
      end
    end

    respond_to do |format|
      if @order_item.save
        format.html { redirect_to @book, notice: t('order.item_added', item: @book) }
      else
        format.html { redirect_to @book, alert: t('order.item_not_added', item: @book) }
      end
    end
  end

  def remove_item
    respond_to do |format|
      if @order_item.reduce_quantity(order_item_params[:quantity])
        format.html { redirect_to cart_path, notice: t('order.item_removed', item: @book) }
      else
        format.html { redirect_to cart_path, notice: t('order.item_not_removed', item: @book) }
      end
    end
  end

  private

    def order_item_params
      params.require(:order_item).permit(:quantity)
    end

    def set_book_and_order_item
      @book = Book.find(params[:book_id])
      @order_item = @current_order.order_items.find_by(book: @book)
    end

end