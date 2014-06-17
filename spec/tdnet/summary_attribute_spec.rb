require 'spec_helper'

module LiteXBRL
  module TDnet
    describe SummaryAttribute do
      include SummaryAttribute

      describe '#attributes' do
        it do
          self.code = 1111
          self.year = 2013
          self.month = 3
          self.quarter = 1
          self.net_sales = 100
          self.operating_income = 10
          self.ordinary_income = 11
          self.net_income = 6
          self.net_income_per_share = 123.1
          self.change_in_net_sales = 200
          self.change_in_operating_income = 20
          self.change_in_ordinary_income = 21
          self.change_in_net_income = 16

          attr = attributes

          expect(attr[:code]).to eq(1111)
          expect(attr[:year]).to eq(2013)
          expect(attr[:quarter]).to eq(1)
          expect(attr[:net_sales]).to eq(100)
          expect(attr[:operating_income]).to eq(10)
          expect(attr[:ordinary_income]).to eq(11)
          expect(attr[:net_income]).to eq(6)
          expect(attr[:net_income_per_share]).to eq(123.1)
          expect(attr[:change_in_net_sales]).to eq(200)
          expect(attr[:change_in_operating_income]).to eq(20)
          expect(attr[:change_in_ordinary_income]).to eq(21)
          expect(attr[:change_in_net_income]).to eq(16)
        end
      end

      describe "#attributes_results_forecast" do
        context '第1四半期' do
          let(:quarter) { 1 }

          it '今期予想' do
            self.code = 1111
            self.year = 2013
            self.month = 3
            self.quarter = quarter
            self.forecast_net_sales = 100
            self.forecast_operating_income = 10
            self.forecast_ordinary_income = 11
            self.forecast_net_income = 6
            self.forecast_net_income_per_share = 123.1
            self.change_in_forecast_net_sales = 200
            self.change_in_forecast_operating_income = 20
            self.change_in_forecast_ordinary_income = 21
            self.change_in_forecast_net_income = 16

            attr = attributes_results_forecast

            expect(attr[:code]).to eq(1111)
            expect(attr[:year]).to eq(2013)
            expect(attr[:quarter]).to eq(4)
            expect(attr[:forecast_net_sales]).to eq(100)
            expect(attr[:forecast_operating_income]).to eq(10)
            expect(attr[:forecast_ordinary_income]).to eq(11)
            expect(attr[:forecast_net_income]).to eq(6)
            expect(attr[:forecast_net_income_per_share]).to eq(123.1)
            expect(attr[:change_in_forecast_net_sales]).to eq(200)
            expect(attr[:change_in_forecast_operating_income]).to eq(20)
            expect(attr[:change_in_forecast_ordinary_income]).to eq(21)
            expect(attr[:change_in_forecast_net_income]).to eq(16)
          end
        end

        context '第4四半期' do
          let(:quarter) { 4 }

          it '来期予想' do
            self.year = 2013
            self.quarter = quarter
            attr = attributes_results_forecast

            expect(attr[:year]).to eq(2014)
          end
        end
      end

    end
  end
end