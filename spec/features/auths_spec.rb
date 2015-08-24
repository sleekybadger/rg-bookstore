require 'rails_helper'

RSpec.feature 'Auths', type: :feature do
  describe 'Sessions' do
    given(:user) { FactoryGirl.create :user }

    scenario 'An user can login successfully, with correct data' do
      visit(new_user_session_path)

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password

      click_button 'Sign in'

      expect(page).not_to have_content 'Sign in'
    end

    scenario 'An user can not login, with bad data' do
      visit(new_user_session_path)

      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password.concat('yoyoyoyo')

      click_button 'Sign in'

      expect(page).to have_content 'Sign in'
    end

    scenario 'An user can logout, he clicks "Logout" link' do
      visit(new_user_session_path)
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Sign in'

      click_link 'Logout'

      expect(page).to have_content 'Sign in'
    end
  end

  describe 'Registrations' do
    given(:user_params) { FactoryGirl.attributes_for :user }

    scenario 'An user can register, with correct data' do
      visit(new_user_registration_path)

      fill_in 'First name', with: user_params[:first_name]
      fill_in 'Last name', with: user_params[:last_name]
      fill_in 'Email', with: user_params[:email]
      fill_in 'Password', with: user_params[:password]
      fill_in 'Password confirmation', with: user_params[:password]

      click_button 'Sign up'

      expect(page).not_to have_content 'Sign up'
    end

    scenario 'An user can not register, with bad data' do
      visit(new_user_registration_path)

      fill_in 'First name', with: user_params[:first_name]
      fill_in 'Last name', with: ''
      fill_in 'Email', with: user_params[:email]
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: ''

      click_button 'Sign up'

      expect(page).to have_content 'Sign up'
    end
  end
end
