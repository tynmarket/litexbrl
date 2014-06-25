require 'spec_helper'

module LiteXBRL
  describe Utils do
    include Utils

    describe '.to_mill' do
      context 'val == "1000000"' do
        let(:val) { "1000000" }
        it { expect(to_mill val).to eq(1) }
      end
    end

    describe '.to_i' do
      context 'val == "54,074"' do
        let(:val) { "54,074" }
        it { expect(to_i val).to eq(54074) }
      end
    end

    describe '.to_f' do
      context 'val == "0.02"' do
        let(:val) { "0.02" }
        it { expect(to_f val).to eq(0.02) }
      end

      context 'val == "1,000.1"' do
        let(:val) { "1,000.1" }
        it { expect(to_f val).to eq 1000.1 }
      end
    end

    describe '.perc_to_f' do
      context 'val == "2.2"' do
        let(:val) { "2.2" }
        it { expect(percent_to_f val).to eq(0.022) }
      end

      context 'val == "1,982.4"' do
        let(:val) { "1,982.4" }
        it { expect(percent_to_f val).to eq 19.824 }
      end
    end

    describe '#present?' do
      context 'val == nil' do
        let(:val) { nil }
        it { expect(present? val).to eq false }
      end

      context 'val == 空文字' do
        let(:val) { "" }
        it { expect(present? val).to eq false }
      end

      context 'val == 2.2' do
        let(:val) { "2.2" }
        it { expect(present? val).to eq true }
      end
    end

    describe '#to_securities_code' do
      context '全角数字' do
        let(:code) { "９６８５０" }

        it "半角数字に直す" do
          allow(code).to receive(:content) { code }
          expect(to_securities_code code).to eq "9685"
        end
      end
    end

    describe '#to_consolidation' do
      context '連結' do
        let(:consolidation) { Utils::CONSOLIDATED }

        it { expect(to_consolidation consolidation).to eq 1 }
      end

      context '非連結' do
        let(:consolidation) { Utils::NON_CONSOLIDATED }

        it { expect(to_consolidation consolidation).to eq 0 }
      end
    end

  end
end