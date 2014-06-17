require 'spec_helper'

module LiteXBRL
  module TDnet
    describe ResultsForecastAttribute do
      include ResultsForecastAttribute

      describe "#attributes" do
        it do
          self.code = 1111
          self.year = 2013
          self.month = 3
          self.quarter = 1
          self.forecast_net_sales = 100
          self.forecast_operating_income = 10
          self.forecast_ordinary_income = 11
          self.forecast_net_income = 6
          self.forecast_net_income_per_share = 123.1

          self.previous_forecast_net_sales = 90
          self.previous_forecast_operating_income = 9
          self.previous_forecast_ordinary_income = 10
          self.previous_forecast_net_income = 5
          self.previous_forecast_net_income_per_share = 113.1

          self.change_forecast_net_sales = 110
          self.change_forecast_operating_income = 20
          self.change_forecast_ordinary_income = 21
          self.change_forecast_net_income = 16

          attr = attributes

          expect(attr[:code]).to eq(1111)
          expect(attr[:year]).to eq(2013)
          expect(attr[:month]).to eq(3)
          expect(attr[:quarter]).to eq(1)
          expect(attr[:forecast_net_sales]).to eq(100)
          expect(attr[:forecast_operating_income]).to eq(10)
          expect(attr[:forecast_ordinary_income]).to eq(11)
          expect(attr[:forecast_net_income]).to eq(6)
          expect(attr[:forecast_net_income_per_share]).to eq(123.1)

          expect(attr[:previous_forecast_net_sales]).to eq(90)
          expect(attr[:previous_forecast_operating_income]).to eq(9)
          expect(attr[:previous_forecast_ordinary_income]).to eq(10)
          expect(attr[:previous_forecast_net_income]).to eq(5)
          expect(attr[:previous_forecast_net_income_per_share]).to eq(113.1)

          expect(attr[:change_forecast_net_sales]).to eq(110)
          expect(attr[:change_forecast_operating_income]).to eq(20)
          expect(attr[:change_forecast_ordinary_income]).to eq(21)
          expect(attr[:change_forecast_net_income]).to eq(16)
        end
      end

    end
  end
end