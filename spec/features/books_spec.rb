require 'rails_helper'

RSpec.feature 'Books', type: :feature do
  given(:book) { FactoryGirl.create :book }
  given(:user) { FactoryGirl.create :user }

  describe 'Add book to wish list' do
    scenario 'A logged user can add book to wishlist' do
      create_session_for user

      visit(book_path(book))

      click_button('Add to wish list')

      expect(page).to have_content('Remove from wish list')
    end

    scenario 'Guest can not add book to wishlist' do
      visit(book_path(book))

      click_button('Add to wish list')

      expect(page).not_to have_content('Remove from wish list')
    end
  end

  describe 'Remove book from wish list' do
    scenario 'An user can add review to wish list' do
      create_session_for user

      visit(book_path(book))

      click_button('Add to wish list')

      click_button('Remove from wish list')

      expect(page).not_to have_content('Remove from wish list')
    end
  end

  describe 'Add review to book' do
    scenario 'A logged user can add review to book' do
      create_session_for user

      visit(new_book_review_path(book))

      select 4, from: 'Rating'
      fill_in 'Note', with: 'Good book'

      click_button('Add new review')

      expect(page).to have_content('Review successfully created')
    end

    scenario 'An user can add review to book only once' do
      create_session_for user

      visit(new_book_review_path(book))

      select 4, from: 'Rating'
      fill_in 'Note', with: 'Good book'

      click_button('Add new review')

      visit(new_book_review_path(book))

      expect(page).not_to have_content('Add new review')
    end

    scenario 'A logged user can not add review to book' do
      visit(new_book_review_path(book))
      expect(page).not_to have_content('Add new review')
    end
  end
end
