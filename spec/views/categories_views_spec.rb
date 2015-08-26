require 'rails_helper'

RSpec.describe 'categories/_categories_list', type: :view do
  let(:category) { FactoryGirl.create :category }

  before { render partial: 'categories/categories_list', locals: { categories: [category] } }

  it { expect(rendered).to have_selector('.categories-list') }
  it { expect(rendered).to have_selector('.categories-list li', count: 1) }
  it { expect(rendered).to match(category.to_s) }
  it { expect(rendered).to match(category_path(category)) }
end

RSpec.describe 'categories/show', type: :view do
  let(:book) { FactoryGirl.create :book }
  let(:books) { Kaminari.paginate_array([book]).page(1) }

  before do
    assign(:books, books)
    assign(:category, book.category)
    assign(:categories, [book.category])

    render
  end

  it { expect(rendered).to match(book.category.to_s) }
  it { expect(view).to render_template(partial: 'books/_books_list', count: 1) }
  it { expect(view).to render_template(partial: 'categories/_categories_list', count: 1) }
end