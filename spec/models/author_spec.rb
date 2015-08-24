require 'rails_helper'

RSpec.describe Author, type: :model do
  subject(:author) { FactoryGirl.create :author }

  context 'Validation' do
    it { expect(author).to validate_presence_of(:first_name) }
    it { expect(author).to validate_presence_of(:last_name) }
  end

  context 'Association' do
    it { expect(author).to have_many(:books) }
  end

  context 'Before save' do
    let(:author) { FactoryGirl.create(:author, first_name: 'john', last_name: 'dou') }

    it 'should capitalize #first_name' do
      expect(author.first_name).to eq 'John'
    end

    it 'should capitalize #last_name' do
      expect(author.last_name).to eq 'Dou'
    end
  end

  describe '.search' do
    it 'should return authors where first_name + last_name match pattern' do
      author = FactoryGirl.create(:author, first_name: 'john', last_name: 'dou')
      expect(Author.search(author.first_name)).to eq [author]
    end
  end

  describe '#to_s' do
    it 'should return #first_name + #last_name' do
      expect(author.to_s).to eq("#{author.first_name} #{author.last_name}")
    end
  end
end
