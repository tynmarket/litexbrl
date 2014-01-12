require 'spec_helper'

module LiteXBRL
  module TDnet
    describe AccountItem do

      describe '.define_item' do
        let(:items) { {jp: ['NetSales'], us: ['NetSalesUS']} }

        it do
          created = AccountItem.define_item(items) {|item| "Forecast#{item}" }

          expect(created[:jp].first).to eq('ForecastNetSales')
          expect(created[:us].first).to eq('ForecastNetSalesUS')
        end
      end

      describe '.define_nested_item' do
        let(:items) { {jp: [['NetSales'], ['NetSales2']], us: [['NetSalesUS']]} }

        it do
          created = AccountItem.define_nested_item(items) {|item| "Forecast#{item}" }

          expect(created[:jp][0][0]).to eq('ForecastNetSales')
          expect(created[:jp][1][0]).to eq('ForecastNetSales2')
          expect(created[:us][0][0]).to eq('ForecastNetSalesUS')
        end
      end

    end
  end
end