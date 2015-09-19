class Settings::BillingAddressesController < Settings::AddressController
  before_filter :create_billing_address, only: :create

  load_and_authorize_resource :billing_address,
    through: :current_user,
    singleton: true,
    class: "Shopper::BillingAddress",
    param_method: :billing_params

  def show
    @billing_address ||= Shopper::BillingAddress.new
  end

  def create
    respond_to do |format|
      if @billing_address.save
        format.html { redirect_to settings_billing_address_path, notice: t('billing.created') }
      else
        format.html { render action: :show }
      end
    end
  end

  def update
    respond_to do |format|
      if @billing_address.update(billing_params)
        format.html { redirect_to settings_billing_address_path, notice: t('billing.updated') }
      else
        format.html { render action: :show }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @billing_address.destroy
        format.html { redirect_to settings_billing_address_path, notice: t('billing.destroyed') }
      else
        format.html { redirect_to settings_billing_address_path, alert: t('billing.not_destroyed') }
      end
    end
  end

  private

  def billing_params
    params.require(:billing_address).permit(*address_fields)
  end

  def create_billing_address
    @billing_address = current_user.build_billing_address(billing_params)
  end
end