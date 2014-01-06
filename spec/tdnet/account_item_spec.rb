require 'spec_helper'

module LiteXBRL
  module TDnet
    describe AccountItem do

      describe '.create_items' do
        let(:items) { {jp: ['NetSales'], us: ['NetSalesUS']} }

        it do
          created = AccountItem.create_items(items) {|item| "Forecast#{item}" }

          expect(created[:jp].first).to eq('ForecastNetSales')
          expect(created[:us].first).to eq('ForecastNetSalesUS')
        end
      end

    end
  end
end