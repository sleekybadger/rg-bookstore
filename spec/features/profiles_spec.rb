require 'rails_helper'

RSpec.feature 'Profiles', type: :feature do
  given(:user) { FactoryGirl.create :user }

  background { create_session_for user }

  scenario 'user can update his info' do
    visit(settings_profile_path)

    within '.update-user-info' do
      fill_in 'First name', with: 'yo'
      click_button 'Save'
    end

    expect(page).to have_content('Information updated')
  end

  scenario 'user can update his password' do
    visit(settings_profile_path)

    within '.update-user-pass' do
      fill_in 'Current password', with: user.password
      fill_in 'Password', with: '12345678'
      fill_in 'Password confirmation', with: '12345678'
      click_button 'Save'
    end

    expect(page).to have_content('Password changed')
  end

  scenario 'user can delete his account' do
    visit(settings_profile_path)

    within '.delete-account' do
      check 'want_to_delete'
      click_button 'Delete'
    end

    expect(page).to have_content('Your account successfully deleted')
  end
end
