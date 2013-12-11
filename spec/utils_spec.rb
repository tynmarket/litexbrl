require 'spec_helper'

module LiteXBRL
  describe Utils do
    include Utils

    describe '.create_items' do
      let(:items) { {jp: ['NetSales'], us: ['NetSalesUS']} }

      it do
        created = self.class.create_items(items) {|item| "Forecast#{item}" }

        expect(created[:jp].first).to eq('ForecastNetSales')
        expect(created[:us].first).to eq('ForecastNetSalesUS')
      end
    end

    describe '.to_mill' do
      context 'val == nil' do
        let(:val) { nil }
        it { expect(self.class.to_mill val).to be_nil }
      end
    end

  end
end