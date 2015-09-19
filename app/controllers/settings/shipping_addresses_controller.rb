class Settings::ShippingAddressesController < Settings::AddressController
  before_filter :create_shipping_address, only: :create

  load_and_authorize_resource :shipping_address,
    through: :current_user,
    singleton: true,
    class: "Shopper::ShippingAddress",
    param_method: :shipping_params

  def show
    @shipping_address ||= Shopper::ShippingAddress.new
  end

  def create
    respond_to do |format|
      if @shipping_address.save
        format.html { redirect_to settings_shipping_address_path, notice: t('shipping.created') }
      else
        format.html { render action: :show }
      end
    end
  end

  def update
    respond_to do |format|
      if @shipping_address.update(shipping_params)
        format.html { redirect_to settings_shipping_address_path, notice: t('shipping.updated') }
      else
        format.html { render action: :show }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @shipping_address.destroy
        format.html { redirect_to settings_shipping_address_path, notice: t('shipping.destroyed') }
      else
        format.html { redirect_to settings_shipping_address_path, alert: t('shipping.not_destroyed') }
      end
    end
  end

  private

  def shipping_params
    params.require(:shipping_address).permit(*address_fields)
  end

  def create_shipping_address
    @shipping_address = current_user.build_shipping_address(shipping_params)
  end
end