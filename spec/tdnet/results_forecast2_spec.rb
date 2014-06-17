require 'spec_helper'
require 'support/nokogiri_helper'

module LiteXBRL
  module TDnet
    describe ResultsForecast do
      include NokogiriHelper

      let(:dir) { File.expand_path '../../data/tdnet/results_forecast2', __FILE__ }

      describe ".read" do
        context '第2四半期・通期' do
          let(:xbrl) { ResultsForecast2.read doc("#{dir}/2q-4q.htm") }
          let(:forecast_q2) { xbrl[:results_forecast].find {|forecast| forecast[:quarter] == 2 } }
          let(:forecast_q4) { xbrl[:results_forecast].find {|forecast| forecast[:quarter] == 4 } }

          it do
            expect(forecast_q2[:code]).to eq "2379"
            expect(forecast_q2[:year]).to eq 2015
            expect(forecast_q2[:month]).to eq 2
            expect(forecast_q2[:quarter]).to eq 2

            expect(forecast_q2[:previous_forecast_net_sales]).to eq 7320
            expect(forecast_q2[:previous_forecast_operating_income]).to eq 467
            expect(forecast_q2[:previous_forecast_ordinary_income]).to eq 462
            expect(forecast_q2[:previous_forecast_net_income]).to eq 237
            expect(forecast_q2[:previous_forecast_net_income_per_share]).to eq 21.43

            expect(forecast_q2[:forecast_net_sales]).to eq 8000
            expect(forecast_q2[:forecast_operating_income]).to eq 746
            expect(forecast_q2[:forecast_ordinary_income]).to eq 744
            expect(forecast_q2[:forecast_net_income]).to eq 392
            expect(forecast_q2[:forecast_net_income_per_share]).to eq 35.49

            expect(forecast_q2[:change_forecast_net_sales]).to eq 0.093
            expect(forecast_q2[:change_forecast_operating_income]).to eq 0.598
            expect(forecast_q2[:change_forecast_ordinary_income]).to eq 0.61
            expect(forecast_q2[:change_forecast_net_income]).to eq 0.658

            expect(forecast_q4[:code]).to eq "2379"
            expect(forecast_q4[:year]).to eq 2015
            expect(forecast_q4[:month]).to eq 2
            expect(forecast_q4[:quarter]).to eq 4

            expect(forecast_q4[:previous_forecast_net_sales]).to eq 15500
            expect(forecast_q4[:previous_forecast_operating_income]).to eq 2250
            expect(forecast_q4[:previous_forecast_ordinary_income]).to eq 2240
            expect(forecast_q4[:previous_forecast_net_income]).to eq 1240
            expect(forecast_q4[:previous_forecast_net_income_per_share]).to eq 112.13

            expect(forecast_q4[:forecast_net_sales]).to eq 16180
            expect(forecast_q4[:forecast_operating_income]).to eq 2529
            expect(forecast_q4[:forecast_ordinary_income]).to eq 2521
            expect(forecast_q4[:forecast_net_income]).to eq 1387
            expect(forecast_q4[:forecast_net_income_per_share]).to eq 125.30

            expect(forecast_q4[:change_forecast_net_sales]).to eq 0.044
            expect(forecast_q4[:change_forecast_operating_income]).to eq 0.124
            expect(forecast_q4[:change_forecast_ordinary_income]).to eq 0.126
            expect(forecast_q4[:change_forecast_net_income]).to eq 0.119
          end
        end

        context '日本会計基準' do
          context "連結" do
            let(:xbrl) { ResultsForecast2.read doc("#{dir}/jp-cons-2014.htm") }
            let(:forecast) { xbrl[:results_forecast].find {|forecast| forecast[:quarter] == 4 } }

            it do
              expect(forecast[:code]).to eq('6883')
              expect(forecast[:year]).to eq(2014)
              expect(forecast[:month]).to eq(3)
              expect(forecast[:quarter]).to eq(4)

              expect(forecast[:previous_forecast_net_sales]).to eq(29000)
              expect(forecast[:previous_forecast_operating_income]).to eq(4150)
              expect(forecast[:previous_forecast_ordinary_income]).to eq(4350)
              expect(forecast[:previous_forecast_net_income]).to eq(3000)
              expect(forecast[:previous_forecast_net_income_per_share]).to eq(45.25)

              expect(forecast[:forecast_net_sales]).to eq(30500)
              expect(forecast[:forecast_operating_income]).to eq(5000)
              expect(forecast[:forecast_ordinary_income]).to eq(5200)
              expect(forecast[:forecast_net_income]).to eq(3800)
              expect(forecast[:forecast_net_income_per_share]).to eq(57.31)

              expect(forecast[:change_forecast_net_sales]).to eq(0.052)
              expect(forecast[:change_forecast_operating_income]).to eq(0.205)
              expect(forecast[:change_forecast_ordinary_income]).to eq(0.195)
              expect(forecast[:change_forecast_net_income]).to eq(0.267)
            end
          end
        end

=begin
        context '米国会計基準' do
          context '連結' do
            let(:xbrl) { ResultsForecast.read("#{dir}/us-cons-2014.xbrl") }

            it do
              expect(xbrl.code).to eq('6594')
              expect(xbrl.year).to eq(2014)
              expect(xbrl.month).to eq(3)
              expect(xbrl.quarter).to eq(4)

              expect(xbrl.forecast_net_sales).to eq(850000)
              expect(xbrl.forecast_operating_income).to eq(80000)
              expect(xbrl.forecast_ordinary_income).to eq(78000)
              expect(xbrl.forecast_net_income).to eq(55000)
              expect(xbrl.forecast_net_income_per_share).to eq(404.26)
              expect(xbrl.previous_forecast_net_sales).to eq(820000)
              expect(xbrl.previous_forecast_operating_income).to eq(75000)
              expect(xbrl.previous_forecast_ordinary_income).to eq(73000)
              expect(xbrl.previous_forecast_net_income).to eq(53500)
              expect(xbrl.previous_forecast_net_income_per_share).to eq(398.72)
            end
          end
        end

        context 'IFRS' do
          context '連結' do
            let(:xbrl) { ResultsForecast.read("#{dir}/ifrs-cons-2014.xbrl") }

            it do
              expect(xbrl.code).to eq('6779')
              expect(xbrl.year).to eq(2014)
              expect(xbrl.month).to eq(3)
              expect(xbrl.quarter).to eq(4)

              expect(xbrl.forecast_net_sales).to eq(51000)
              expect(xbrl.forecast_operating_income).to eq(700)
              expect(xbrl.forecast_ordinary_income).to eq(500)
              expect(xbrl.forecast_net_income).to eq(400)
              expect(xbrl.forecast_net_income_per_share).to eq(20.38)
              expect(xbrl.previous_forecast_net_sales).to eq(51000)
              expect(xbrl.previous_forecast_operating_income).to eq(1500)
              expect(xbrl.previous_forecast_ordinary_income).to eq(1100)
              expect(xbrl.previous_forecast_net_income).to eq(1000)
              expect(xbrl.previous_forecast_net_income_per_share).to eq(50.95)
            end
          end
        end
=end

        context '1Q予想' do
          let(:xbrl) { ResultsForecast2.read doc("#{dir}/1q.htm") }
          let(:forecast) { xbrl[:results_forecast].find {|forecast| forecast[:quarter] == 1 } }

          it do
            expect(forecast[:code]).to eq('3656')
            expect(forecast[:year]).to eq(2014)
            expect(forecast[:month]).to eq(12)
            expect(forecast[:quarter]).to eq(1)

            expect(forecast[:previous_forecast_net_sales]).to eq(4050)
            expect(forecast[:previous_forecast_operating_income]).to eq(-90)
            expect(forecast[:previous_forecast_ordinary_income]).to eq(-86)
            expect(forecast[:previous_forecast_net_income]).to eq(-86)
            expect(forecast[:previous_forecast_net_income_per_share]).to eq(-2.61)

            expect(forecast[:forecast_net_sales]).to eq(4425)
            expect(forecast[:forecast_operating_income]).to eq(96)
            expect(forecast[:forecast_ordinary_income]).to eq(106)
            expect(forecast[:forecast_net_income]).to eq(51)
            expect(forecast[:forecast_net_income_per_share]).to eq(1.56)

            expect(forecast[:change_forecast_net_sales]).to eq(0.093)
            expect(forecast[:change_forecast_operating_income]).to be_nil
            expect(forecast[:change_forecast_ordinary_income]).to be_nil
            expect(forecast[:change_forecast_net_income]).to be_nil
          end
        end

        context '3Q予想' do
          let(:xbrl) { ResultsForecast2.read doc("#{dir}/3q.htm") }
          let(:forecast) { xbrl[:results_forecast].find {|forecast| forecast[:quarter] == 3 } }

          it do
            expect(forecast[:code]).to eq('8742')
            expect(forecast[:year]).to eq(2014)
            expect(forecast[:month]).to eq(3)
            expect(forecast[:quarter]).to eq(3)

            expect(forecast[:previous_forecast_net_sales]).to be_nil
            expect(forecast[:previous_forecast_operating_income]).to be_nil
            expect(forecast[:previous_forecast_ordinary_income]).to be_nil
            expect(forecast[:previous_forecast_net_income]).to be_nil
            expect(forecast[:previous_forecast_net_income_per_share]).to be_nil

            expect(forecast[:forecast_net_sales]).to eq 2332
            expect(forecast[:forecast_operating_income]).to eq -470
            expect(forecast[:forecast_ordinary_income]).to eq -389
            expect(forecast[:forecast_net_income]).to eq -86
            expect(forecast[:forecast_net_income_per_share]).to be_nil

            expect(forecast[:change_forecast_net_sales]).to be_nil
            expect(forecast[:change_forecast_operating_income]).to be_nil
            expect(forecast[:change_forecast_ordinary_income]).to be_nil
            expect(forecast[:change_forecast_net_income]).to be_nil
          end
        end

        context 'レンジ予想' do
          let(:xbrl) { ResultsForecast2.read doc("#{dir}/range.htm") }
          let(:forecast) { xbrl[:results_forecast].find {|forecast| forecast[:quarter] == 4 } }

          it do
            expect(forecast[:code]).to eq('4918')
            expect(forecast[:year]).to eq(2014)
            expect(forecast[:month]).to eq(3)
            expect(forecast[:quarter]).to eq(4)

            expect(forecast[:previous_forecast_net_sales]).to be_nil
            expect(forecast[:previous_forecast_operating_income]).to be_nil
            expect(forecast[:previous_forecast_ordinary_income]).to be_nil
            expect(forecast[:previous_forecast_net_income]).to be_nil
            expect(forecast[:previous_forecast_net_income_per_share]).to be_nil

            expect(forecast[:forecast_net_sales]).to be_nil
            expect(forecast[:forecast_operating_income]).to be_nil
            expect(forecast[:forecast_ordinary_income]).to be_nil
            expect(forecast[:forecast_net_income]).to be_nil
            expect(forecast[:forecast_net_income_per_share]).to be_nil

            expect(forecast[:change_forecast_net_sales]).to be_nil
            expect(forecast[:change_forecast_operating_income]).to be_nil
            expect(forecast[:change_forecast_ordinary_income]).to be_nil
            expect(forecast[:change_forecast_net_income]).to be_nil
          end
        end
      end

    end
  end
end