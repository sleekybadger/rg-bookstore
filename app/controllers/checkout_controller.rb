class CheckoutController < ApplicationController
  include Wicked::Wizard
  include CurrentOrder

  before_action :check_cart_items, :set_user

  steps :address, :delivery, :payment, :confirm

  def show
    case step.to_sym
      when :address
        address
      when :delivery
        delivery
      when :payment
        payment
      when :confirm
        confirm
      when :wicked_finish
        wizard_finish
      else
        not_found
    end

    render_wizard
  end

  def update
    case step.to_sym
      when :address
        update_address
      when :delivery
        update_delivery
      when :payment
        update_payment
      when :confirm
        place_order
      else
        not_found
    end

    render_wizard @current_order
  end

  private

    def address
      @countries = Country.all

      unless @current_order.billing_address
        if @user.billing_address
          @current_order.build_billing_address(@user.billing_address.dup.attributes)
        else
          @current_order.build_billing_address
        end
      end

      unless @current_order.shipping_address
        if @user.shipping_address
          @current_order.build_shipping_address(@user.shipping_address.dup.attributes)
        else
          @current_order.build_shipping_address
        end
      end
    end

    def update_address
      @countries = Country.all

      attributes = address_params

      if params[:same_as_billing]
        attributes[:shipping_address_attributes] = attributes[:billing_address_attributes]
      end

      @current_order.assign_attributes(attributes)
    end

    def delivery
      @deliveries = Delivery.all
    end

    def update_delivery
      @deliveries = Delivery.all
      @current_order.assign_attributes(delivery_params)
    end

    def payment
      @current_order.build_credit_card unless @current_order.credit_card
    end

    def update_payment
      @current_order.assign_attributes(card_params)
    end

    def confirm
      unless step_completed?(:address)
        flash[:alert] = t('checkout.fill_address')

        jump_to(:address) and return
      end

      unless step_completed?(:delivery)
        flash[:alert] = t('checkout.fill_delivery')

        jump_to(:delivery) and return
      end

      unless step_completed?(:payment)
        flash[:alert] = t('checkout.fill_payment')

        jump_to(:payment) and return
      end
    end

    def place_order
      @current_order.place_order!

      unless @current_order.in_queue?
        jump_to(:confirm) and return
      end

      @current_order.user = @user
    end

    def wizard_finish
      flash[:order_id] = @current_order.id
      flash[:notice] = t('checkout.order_created')

      create_current_order
    end

    def finish_wizard_path
      complete_cart_path
    end

    def check_cart_items
      not_found if @current_order.order_items.empty?
    end

    def set_user
      @user = current_user || User.new
    end

    def step_completed?(step)
      case step
        when :address
          @current_order.billing_address && @current_order.shipping_address
        when :delivery
          @current_order.delivery
        when :payment
          @current_order.credit_card
        else
          false
      end
    end

    def address_params
      params.require(:order).permit(
          :same_as_billing,
          billing_address_attributes: address_fields,
          shipping_address_attributes: address_fields
      )
    end

    def delivery_params
      params.require(:order).permit(:delivery_id)
    end

    def card_params
      params.require(:order).permit(
          credit_card_attributes: %i(number expiration_month expiration_year cvv)
      )
    end

    def address_fields
      %i(first_name last_name street city zip phone type country_id)
    end

end