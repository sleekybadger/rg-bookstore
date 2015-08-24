require 'rails_helper'

RSpec.feature 'Searches', type: :feature do
  given(:book) { FactoryGirl.create :book }
  given(:author) { FactoryGirl.create :author }

  scenario 'An user can search by book title' do
    visit(search_path)

    fill_in 'query', with: book.title[0..1]
    choose 'by books'
    click_button 'Search'

    expect(page).to have_content(book.title)
  end

  scenario 'An user can search by author name' do
    visit(search_path)

    fill_in 'query', with: author.to_s[0..1]
    choose 'by authors'
    click_button 'Search'

    expect(page).to have_content(author.to_s)
  end
end
