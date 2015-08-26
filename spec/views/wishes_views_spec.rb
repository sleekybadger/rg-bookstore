require 'rails_helper'

RSpec.describe 'wishes/index', type: :view do
  let(:user) { FactoryGirl.create :user }
  let(:book) { FactoryGirl.create :book }

  before { assign(:user, user) }

  context 'current user wishes' do
    before { allow(view).to receive(:can?).with(:update, user) { true } }

    context 'wishes empty' do
      before { render }

      it { expect(rendered).to have_selector('.wishes-for', text: t('wishes.my_empty')) }
    end

    context 'wishes not empty' do
      before do
        user.wishes << book

        render
      end

      it { expect(rendered).to have_selector('.wishes-for', text: t('wishes.my_wishes')) }
      it { expect(rendered).to have_selector('.wishes-list li form', count: 1 ) }
    end
  end

  context 'foreign user wishes' do
    before { allow(view).to receive(:can?).with(:update, user) { false } }

    context 'wishes empty' do
      before { render }

      it { expect(rendered).to have_selector('.wishes-for', text:  t('wishes.user_empty', user: user)) }
    end

    context 'wishes not empty' do
      before do
        user.wishes << book

        render
      end

      it { expect(rendered).to have_selector('.wishes-for', text: t('wishes.user_wishes', user: user)) }
      it { expect(rendered).not_to have_selector('.wishes-list li form', count: 1 ) }
    end
  end

  context 'with wishes' do
    before do
      user.wishes << book
      allow(view).to receive(:can?).with(:update, user) { false }

      render
    end

    it { expect(rendered).to have_selector('.wishes-list') }
    it { expect(rendered).to have_selector('.wishes-list li', count: 1 ) }
    it { expect(rendered).to match(book.to_s) }
    it { expect(rendered).to match(book_path(book)) }
  end
end
