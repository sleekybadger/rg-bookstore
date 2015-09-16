require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '.title' do
    it 'should sets content for :title' do
      helper.title 'yoyoy'
      expect(helper.content_for(:title)).to match('yoyoy')
    end
  end

  describe '.glyph_icon' do
    it 'should return i tag' do
      expect(helper.glyph_icon :star).to have_selector('i')
    end

    it 'should add class glyphicon' do
      expect(helper.glyph_icon :star).to have_selector('.glyphicon')
    end

    it 'should add first_param as class with + glyphicon-' do
      expect(helper.glyph_icon :star).to have_selector('.glyphicon-star')
    end

    it 'should transform snake case to dashed' do
      expect(helper.glyph_icon :super_star).to have_selector('.glyphicon-super-star')
    end
  end

  describe '.current_p?' do
    before { allow(helper).to receive_message_chain(:request, :path) { '/yo' } }

    it { expect(helper.current_p?('/yo')).to be_truthy }
    it { expect(helper.current_p?('/pam')).to be_falsey }
  end

  describe '.resource_name' do
    it { expect(helper.resource_name).to eq(:user) }
  end

  describe '.resource' do
    let!(:user) { User.new }

    before { allow(User).to receive(:new) { user } }

    it { expect(helper.resource).to eq(user) }
    it 'should not assigns @resource, if there value' do
      assign(:resource, 'yo')

      expect(helper.resource).not_to eq(user)
    end
  end

  describe '.devise_mapping' do
    let!(:mapping) { double('Mapping') }

    before { allow(Devise).to receive(:mappings) { { user: mapping } } }

    it { expect(helper.devise_mapping).to eq(mapping) }
    it 'should not assigns @devise_mapping, if there value' do
      assign(:devise_mapping, 'yo')

      expect(helper.devise_mapping).not_to eq(mapping)
    end
  end
end
