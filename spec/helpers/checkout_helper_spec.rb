require 'rails_helper'

RSpec.describe CheckoutHelper, type: :helper do
  describe '.wizard_progress' do
    let(:helper) { Object.new.extend CheckoutHelper, Wicked::Controller::Concerns::Steps }

    before do
      allow(helper).to receive(:wizard_steps) { %i(first second third) }
      allow(helper).to receive(:past_step?) { false }
      allow(helper).to receive(:step)
    end

    it { expect(helper.wizard_progress).to be_a Array }
    it { expect(helper.wizard_progress[0][:name]).to eq(:first) }

    context 'step passed' do
      before { allow(helper).to receive(:past_step?) { true } }

      it { expect(helper.wizard_progress[0][:classes]).to match('finished') }
    end

    context 'step active' do
      before { allow(helper).to receive(:step) { :first } }

      it { expect(helper.wizard_progress[0][:classes]).to match('active') }
    end
  end

  describe '.months_for_select' do
    it { expect(helper.months_for_select).to be_a Array }
    it { expect(helper.months_for_select.size).to eq(12) }
    it { expect(helper.months_for_select.map { |m| m[0] }).to eq(Date::MONTHNAMES.compact) }
  end
end