require 'spec_helper'

module LiteXBRL
  describe Utils do
    include Utils

    describe '.to_mill' do
      context 'val == "1000000"' do
        let(:val) { "1000000" }
        it { expect(self.class.to_mill val).to eq(1) }
      end
    end

    describe '.to_i' do
      context 'val == "54,074"' do
        let(:val) { "54,074" }
        it { expect(self.class.to_i val).to eq(54074) }
      end
    end

    describe '.to_f' do
      context 'val == "0.02"' do
        let(:val) { "0.02" }
        it { expect(self.class.to_f val).to eq(0.02) }
      end
    end

    describe '.perc_to_f' do
      context 'val == "2.2"' do
        let(:val) { "2.2" }
        it { expect(self.class.percent_to_f val).to eq(0.022) }
      end
    end

    describe '#present?' do
      context 'val == nil' do
        let(:val) { nil }
        it { expect(self.class.present? val).to be_false }
      end

      context 'val == 空文字' do
        let(:val) { "" }
        it { expect(self.class.present? val).to be_false }
      end

      context 'val == 2.2' do
        let(:val) { "2.2" }
        it { expect(self.class.present? val).to be_true }
      end
    end

    describe '#to_securities_code' do
      context '全角数字' do
        let(:code) { "９６８５０" }

        it "半角数字に直す" do
          code.stub(:content) { code }
          expect(self.class.to_securities_code code).to eq "9685"
        end
      end
    end

  end
end