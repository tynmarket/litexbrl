require 'spec_helper'
require 'support/nokogiri_helper'

module LiteXBRL
  module TDnet
    describe ResultsForecast do
      include NokogiriHelper

      let(:dir) { File.expand_path '../../data/tdnet/results_forecast', __FILE__ }

      describe ".read" do
        context '日本会計基準' do
          context "連結" do
            let(:xbrl) { (ResultsForecast.read doc("#{dir}/jp-cons-2012.xbrl"))[:results_forecast][1] }

            it do
              expect(xbrl[:code]).to eq('4368')
              expect(xbrl[:year]).to eq(2012)
              expect(xbrl[:month]).to eq(3)
              expect(xbrl[:quarter]).to eq(4)

              expect(xbrl[:forecast_net_sales]).to eq(28300)
              expect(xbrl[:forecast_operating_income]).to eq(3850)
              expect(xbrl[:forecast_ordinary_income]).to eq(3700)
              expect(xbrl[:forecast_net_income]).to eq(2400)
              expect(xbrl[:forecast_net_income_per_share]).to eq(380.87)

              expect(xbrl[:previous_forecast_net_sales]).to eq(30300)
              expect(xbrl[:previous_forecast_operating_income]).to eq(4700)
              expect(xbrl[:previous_forecast_ordinary_income]).to eq(4400)
              expect(xbrl[:previous_forecast_net_income]).to eq(3050)
              expect(xbrl[:previous_forecast_net_income_per_share]).to eq(484.02)

              expect(xbrl[:change_forecast_net_sales]).to eq(-0.066)
              expect(xbrl[:change_forecast_operating_income]).to eq(-0.181)
              expect(xbrl[:change_forecast_ordinary_income]).to eq(-0.159)
              expect(xbrl[:change_forecast_net_income]).to eq(-0.213)
            end
          end
        end

        context '米国会計基準' do
          context '連結' do
            let(:xbrl) { (ResultsForecast.read doc("#{dir}/us-cons-2014.xbrl"))[:results_forecast][1] }

            it do
              expect(xbrl[:code]).to eq('6594')
              expect(xbrl[:year]).to eq(2014)
              expect(xbrl[:month]).to eq(3)
              expect(xbrl[:quarter]).to eq(4)

              expect(xbrl[:forecast_net_sales]).to eq(850000)
              expect(xbrl[:forecast_operating_income]).to eq(80000)
              expect(xbrl[:forecast_ordinary_income]).to eq(78000)
              expect(xbrl[:forecast_net_income]).to eq(55000)
              expect(xbrl[:forecast_net_income_per_share]).to eq(404.26)

              expect(xbrl[:previous_forecast_net_sales]).to eq(820000)
              expect(xbrl[:previous_forecast_operating_income]).to eq(75000)
              expect(xbrl[:previous_forecast_ordinary_income]).to eq(73000)
              expect(xbrl[:previous_forecast_net_income]).to eq(53500)
              expect(xbrl[:previous_forecast_net_income_per_share]).to eq(398.72)

              expect(xbrl[:change_forecast_net_sales]).to eq(0.037)
              expect(xbrl[:change_forecast_operating_income]).to eq(0.067)
              expect(xbrl[:change_forecast_ordinary_income]).to eq(0.068)
              expect(xbrl[:change_forecast_net_income]).to eq(0.028)
            end
          end
        end

        context 'IFRS' do
          context '連結' do
            let(:xbrl) { (ResultsForecast.read doc("#{dir}/ifrs-cons-2014.xbrl"))[:results_forecast][1] }

            it do
              expect(xbrl[:code]).to eq('6779')
              expect(xbrl[:year]).to eq(2014)
              expect(xbrl[:month]).to eq(3)
              expect(xbrl[:quarter]).to eq(4)

              expect(xbrl[:forecast_net_sales]).to eq(51000)
              expect(xbrl[:forecast_operating_income]).to eq(700)
              expect(xbrl[:forecast_ordinary_income]).to eq(500)
              expect(xbrl[:forecast_net_income]).to eq(400)
              expect(xbrl[:forecast_net_income_per_share]).to eq(20.38)

              expect(xbrl[:previous_forecast_net_sales]).to eq(51000)
              expect(xbrl[:previous_forecast_operating_income]).to eq(1500)
              expect(xbrl[:previous_forecast_ordinary_income]).to eq(1100)
              expect(xbrl[:previous_forecast_net_income]).to eq(1000)
              expect(xbrl[:previous_forecast_net_income_per_share]).to eq(50.95)

#              expect(xbrl[:change_forecast_net_sales]).to eq(0.037)
              expect(xbrl[:change_forecast_operating_income]).to eq(-0.533)
              expect(xbrl[:change_forecast_ordinary_income]).to eq(-0.545)
              expect(xbrl[:change_forecast_net_income]).to eq(-0.6)
            end
          end
        end
      end

      describe "#attributes" do
        it do
          results_forecast = ResultsForecast.new
          results_forecast.code = 1111
          results_forecast.year = 2013
          results_forecast.month = 3
          results_forecast.quarter = 1
          results_forecast.forecast_net_sales = 100
          results_forecast.forecast_operating_income = 10
          results_forecast.forecast_ordinary_income = 11
          results_forecast.forecast_net_income = 6
          results_forecast.forecast_net_income_per_share = 123.1

          results_forecast.previous_forecast_net_sales = 90
          results_forecast.previous_forecast_operating_income = 9
          results_forecast.previous_forecast_ordinary_income = 10
          results_forecast.previous_forecast_net_income = 5
          results_forecast.previous_forecast_net_income_per_share = 113.1

          results_forecast.change_forecast_net_sales = 110
          results_forecast.change_forecast_operating_income = 20
          results_forecast.change_forecast_ordinary_income = 21
          results_forecast.change_forecast_net_income = 16

          attr = results_forecast.attributes

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