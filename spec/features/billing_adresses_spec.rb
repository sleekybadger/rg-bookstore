require 'rails_helper'

RSpec.feature 'BillingAdresses', type: :feature do
  given(:user) { FactoryGirl.create :user }
  given!(:country) { FactoryGirl.create :country }

  background { create_session_for user }

  scenario 'A user can add billing address to his profile' do
    visit(settings_billing_address_path)

    within '.new_billing_address' do
      fill_in 'First name', with: user.first_name
      fill_in 'Last name', with: user.first_name
      select country.name, from: 'billing_address_country_id'
      fill_in 'City', with: 'New York'
      fill_in 'Street', with: 'Yoyoyo'
      fill_in 'Zip', with: '111'
      fill_in 'Phone', with: '+1231124125'
    end

    click_button 'Save'

    expect(page).to have_content 'Billing address successfully created'
  end

  scenario 'A user can update his profile billing address' do
    FactoryGirl.create :billing_address, addressable: user

    visit(settings_billing_address_path)

    fill_in 'Phone', with: '+1231124125'

    click_button 'Save'

    expect(page).to have_content 'Billing address successfully updated'
  end

  scenario 'A user can delete his profile billing address' do
    FactoryGirl.create :billing_address, addressable: user

    visit(settings_billing_address_path)

    click_button 'Delete'

    expect(page).to have_content 'Billing address successfully deleted'
  end
end
