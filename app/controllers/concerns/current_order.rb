module CurrentOrder

  extend ActiveSupport::Concern

  def current_order
    @current_order
  end

  private

    def set_current_order
      begin
        @current_order = Order.find(session[:order_id])
      rescue ActiveRecord::RecordNotFound
        create_current_order
      end
    end

    def create_current_order
      @current_order = Order.create
      session[:order_id] = @current_order.id
    end

end