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
              expect(xbrl[:consolidation]).to eq(1)

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

          context '非連結' do
            let(:xbrl) { (ResultsForecast.read doc("#{dir}/jp-noncons-2014.xbrl"))[:results_forecast][1] }

            it do
              expect(xbrl[:code]).to eq "4082"
              expect(xbrl[:year]).to eq 2014
              expect(xbrl[:month]).to eq 3
              expect(xbrl[:quarter]).to eq 4
              expect(xbrl[:consolidation]).to eq 0

              expect(xbrl[:forecast_net_sales]).to eq 20300
              expect(xbrl[:forecast_operating_income]).to eq 2400
              expect(xbrl[:forecast_ordinary_income]).to eq 2400
              expect(xbrl[:forecast_net_income]).to eq 2600
              expect(xbrl[:forecast_net_income_per_share]).to eq 540.36

              expect(xbrl[:previous_forecast_net_sales]).to eq 19000
              expect(xbrl[:previous_forecast_operating_income]).to eq 1500
              expect(xbrl[:previous_forecast_ordinary_income]).to eq 1500
              expect(xbrl[:previous_forecast_net_income]).to eq 1500
              expect(xbrl[:previous_forecast_net_income_per_share]).to eq 311.75

              expect(xbrl[:change_forecast_net_sales]).to eq 0.068
              expect(xbrl[:change_forecast_operating_income]).to eq 0.6
              expect(xbrl[:change_forecast_ordinary_income]).to eq 0.6
              expect(xbrl[:change_forecast_net_income]).to eq 0.733
            end
          end

          context '連結銘柄の個別予想' do
            let(:xbrl) { (ResultsForecast.read doc("#{dir}/jp-noncons-cons.xbrl"))[:results_forecast][0] }

            it do
              expect(xbrl[:code]).to eq "6856"
              expect(xbrl[:year]).to eq 2011
              expect(xbrl[:month]).to eq 12
              expect(xbrl[:quarter]).to eq 2
              expect(xbrl[:consolidation]).to eq 0

              expect(xbrl[:forecast_net_sales]).to eq 24500
              expect(xbrl[:forecast_operating_income]).to eq 2200
              expect(xbrl[:forecast_ordinary_income]).to eq 4600
              expect(xbrl[:forecast_net_income]).to eq 3700
              expect(xbrl[:forecast_net_income_per_share]).to eq 87.49

              expect(xbrl[:previous_forecast_net_sales]).to eq 24000
              expect(xbrl[:previous_forecast_operating_income]).to eq 800
              expect(xbrl[:previous_forecast_ordinary_income]).to eq 3000
              expect(xbrl[:previous_forecast_net_income]).to eq 2500
              expect(xbrl[:previous_forecast_net_income_per_share]).to eq 59.12

              expect(xbrl[:change_forecast_net_sales]).to eq 0.021
              expect(xbrl[:change_forecast_operating_income]).to eq 1.75
              expect(xbrl[:change_forecast_ordinary_income]).to eq 0.533
              expect(xbrl[:change_forecast_net_income]).to eq 0.48
            end
          end

          context '第2四半期' do
            let(:xbrl) { (ResultsForecast.read doc("#{dir}/jp-noncons-q2.xbrl"))[:results_forecast][0] }

            it do
              expect(xbrl[:code]).to eq "7501"
              expect(xbrl[:year]).to eq 2011
              expect(xbrl[:month]).to eq 11
              expect(xbrl[:quarter]).to eq 2
              expect(xbrl[:consolidation]).to eq 0

              expect(xbrl[:forecast_net_sales]).to eq 1410
              expect(xbrl[:forecast_operating_income]).to eq 39
              expect(xbrl[:forecast_ordinary_income]).to eq 45
              expect(xbrl[:forecast_net_income]).to eq 4
              expect(xbrl[:forecast_net_income_per_share]).to eq 1.68

              expect(xbrl[:previous_forecast_net_sales]).to eq 1470
              expect(xbrl[:previous_forecast_operating_income]).to eq 52
              expect(xbrl[:previous_forecast_ordinary_income]).to eq 55
              expect(xbrl[:previous_forecast_net_income]).to eq 10
              expect(xbrl[:previous_forecast_net_income_per_share]).to eq 3.87

              expect(xbrl[:change_forecast_net_sales]).to eq -0.041
              expect(xbrl[:change_forecast_operating_income]).to eq -0.237
              expect(xbrl[:change_forecast_ordinary_income]).to eq -0.174
              expect(xbrl[:change_forecast_net_income]).to eq -0.566
            end
          end

          context 'find_consolidation修正' do
            let(:xbrl) { (ResultsForecast.read doc("#{dir}/find_consolidation.xbrl"))[:results_forecast][1] }

            it do
              expect(xbrl[:code]).to eq "3181"
              expect(xbrl[:year]).to eq 2014
              expect(xbrl[:month]).to eq 2
              expect(xbrl[:quarter]).to eq 4
              expect(xbrl[:consolidation]).to eq 0

              expect(xbrl[:forecast_net_sales]).to eq 5288
              expect(xbrl[:forecast_operating_income]).to eq 250  # 本当は243（XBRLが間違い）
              expect(xbrl[:forecast_ordinary_income]).to eq 250
              expect(xbrl[:forecast_net_income]).to eq 143
              expect(xbrl[:forecast_net_income_per_share]).to eq 81.88

              expect(xbrl[:previous_forecast_net_sales]).to eq 5840
              expect(xbrl[:previous_forecast_operating_income]).to eq 515
              expect(xbrl[:previous_forecast_ordinary_income]).to eq 515
              expect(xbrl[:previous_forecast_net_income]).to eq 296
              expect(xbrl[:previous_forecast_net_income_per_share]).to eq 168.75

              expect(xbrl[:change_forecast_net_sales]).to eq -0.094
              expect(xbrl[:change_forecast_operating_income]).to eq -0.515  # 本当は-0.528（XBRLが間違い）
              expect(xbrl[:change_forecast_ordinary_income]).to eq -0.515
              expect(xbrl[:change_forecast_net_income]).to eq -0.515
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
              expect(xbrl[:consolidation]).to eq(1)

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
              expect(xbrl[:consolidation]).to eq(1)

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

    end
  end
end