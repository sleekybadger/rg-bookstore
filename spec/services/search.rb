require 'rails_helper'

RSpec.describe Search do
  describe '#search' do
    context 'by books' do
      let(:search) { Search.new('yoyo', 'books') }

      it 'expect to receive :search for Book' do
        expect(Book).to receive(:search).with('yoyo')
        search.search
      end
    end

    context 'by authors' do
      let(:search) { Search.new('yoyo', 'authors') }

      it 'expect to receive :search for Author' do
        expect(Author).to receive(:search).with('yoyo')
        search.search
      end
    end
  end
end