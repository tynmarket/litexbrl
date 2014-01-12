require 'spec_helper'

module LiteXBRL
  describe Utils do
    include Utils

    describe '.to_mill' do
      context 'val == nil' do
        let(:val) { nil }
        it { expect(self.class.to_mill val).to be_nil }
      end
    end

    describe '.to_f' do
      context 'val == nil' do
        let(:val) { nil }
        it { expect(self.class.to_f val).to be_nil }
      end
    end

    describe '.perc_to_f' do
      context '' do
        let(:val) { 2.2 }
        it { expect(self.class.percent_to_f val).to eq(0.022) }
      end

      context 'val == nil' do
        let(:val) { nil }
        it { expect(self.class.percent_to_f val).to be_nil }
      end
    end

  end
end