class Settings::AddressController < ApplicationController
  before_filter :authenticate_user!

  before_action :set_countries

  private

    def set_countries
      @countries = Country.all
    end

    def address_fields
      %i(first_name last_name street city zip phone type country_id)
    end

end