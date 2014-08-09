require 'spec_helper'
require 'support/nokogiri_helper'

module LiteXBRL
  module TDnet
    describe Summary2 do
      include NokogiriHelper

      let(:dir) { File.expand_path '../../data/tdnet/summary2', __FILE__ }

      describe ".find_consolidation" do
        it "非連結" do
          consolidation = Summary2.send(:find_consolidation, doc("#{dir}/jp-noncons-2014-q4.htm"), Summary2::SEASON_Q4, AccountItem::NET_SALES)
          expect(consolidation).to eq "NonConsolidated"
        end
      end

      describe ".context_hash" do
        let(:consolidation) { 'Consolidated' }
        let(:season) { 'AccumulatedQ1' }
        let(:quarter) { 1 }

        it "context" do
          context_hash = Summary2.send(:context_hash, consolidation, season)

          expect(context_hash[:context_duration]).to eq('CurrentAccumulatedQ1Duration_ConsolidatedMember_ResultMember')
          expect(context_hash[:context_instant]).to eq('CurrentAccumulatedQ1Instant')
          expect(context_hash[:context_forecast].call(quarter)).to eq('CurrentYearDuration_ConsolidatedMember_ForecastMember')
        end
      end

      describe ".read" do
        context '日本会計基準' do
          context "連結・第1四半期" do
            let(:xbrl) { Summary2.read doc("#{dir}/jp-cons-2014-q1.htm") }
            let(:summary) { xbrl[:summary] }
            let(:results_forecast) { xbrl[:results_forecast].first }

            it do
              expect(summary[:code]).to eq('3046')
              expect(summary[:year]).to eq(2014)
              expect(summary[:month]).to eq(8)
              expect(summary[:quarter]).to eq(1)
              expect(summary[:consolidation]).to eq(1)

              expect(summary[:net_sales]).to eq(8168)
              expect(summary[:operating_income]).to eq(249)
              expect(summary[:ordinary_income]).to eq(219)
              expect(summary[:net_income]).to eq(70)
              expect(summary[:net_income_per_share]).to eq(2.92)

              expect(summary[:change_in_net_sales]).to eq(0.047)
              expect(summary[:change_in_operating_income]).to eq(-0.819)
              expect(summary[:change_in_ordinary_income]).to eq(-0.832)
              expect(summary[:change_in_net_income]).to eq(-0.909)

              expect(summary[:prior_net_sales]).to eq(7799)
              expect(summary[:prior_operating_income]).to eq(1377)
              expect(summary[:prior_ordinary_income]).to eq(1301)
              expect(summary[:prior_net_income]).to eq(766)
              expect(summary[:prior_net_income_per_share]).to eq(31.95)

              expect(summary[:change_in_prior_net_sales]).to eq(0.853)
              expect(summary[:change_in_prior_operating_income]).to eq(6.587)
              expect(summary[:change_in_prior_ordinary_income]).to eq(6.641)
              expect(summary[:change_in_prior_net_income]).to be_nil

              expect(results_forecast[:forecast_net_sales]).to eq(40600)
              expect(results_forecast[:forecast_operating_income]).to eq(6800)
              expect(results_forecast[:forecast_ordinary_income]).to eq(6850)
              expect(results_forecast[:forecast_net_income]).to eq(3900)
              expect(results_forecast[:forecast_net_income_per_share]).to eq(162.66)

              expect(results_forecast[:change_in_forecast_net_sales]).to eq(0.111)
              expect(results_forecast[:change_in_forecast_operating_income]).to eq(0.093)
              expect(results_forecast[:change_in_forecast_ordinary_income]).to eq(0.167)
              expect(results_forecast[:change_in_forecast_net_income]).to eq(0.141)
            end
          end

          context "連結・第4四半期" do
            let(:xbrl) { Summary2.read doc("#{dir}/jp-cons-2013-q4.htm") }
            let(:summary) { xbrl[:summary] }
            let(:results_forecast) { xbrl[:results_forecast].first }

            it do
              expect(summary[:code]).to eq('2408')
              expect(summary[:year]).to eq(2013)
              expect(summary[:month]).to eq(12)
              expect(summary[:quarter]).to eq(4)
              expect(summary[:consolidation]).to eq(1)

              expect(summary[:net_sales]).to eq(4691)
              expect(summary[:operating_income]).to eq(759)
              expect(summary[:ordinary_income]).to eq(821)
              expect(summary[:net_income]).to eq(493)
              expect(summary[:net_income_per_share]).to eq(67.03)

              expect(summary[:change_in_net_sales]).to eq(-0.008)
              expect(summary[:change_in_operating_income]).to eq(-0.206)
              expect(summary[:change_in_ordinary_income]).to eq(-0.184)
              expect(summary[:change_in_net_income]).to eq(-0.147)

              expect(summary[:prior_net_sales]).to eq(4727)
              expect(summary[:prior_operating_income]).to eq(956)
              expect(summary[:prior_ordinary_income]).to eq(1005)
              expect(summary[:prior_net_income]).to eq(579)
              expect(summary[:prior_net_income_per_share]).to eq(79.73)

              expect(summary[:change_in_prior_net_sales]).to eq(0.008)
              expect(summary[:change_in_prior_operating_income]).to eq(0.036)
              expect(summary[:change_in_prior_ordinary_income]).to eq(0.039)
              expect(summary[:change_in_prior_net_income]).to eq(0.287)

              expect(results_forecast[:forecast_net_sales]).to eq(5064)
              expect(results_forecast[:forecast_operating_income]).to eq(509)
              expect(results_forecast[:forecast_ordinary_income]).to eq(530)
              expect(results_forecast[:forecast_net_income]).to eq(316)
              expect(results_forecast[:forecast_net_income_per_share]).to eq(42.91)

              expect(results_forecast[:change_in_forecast_net_sales]).to eq(0.079)
              expect(results_forecast[:change_in_forecast_operating_income]).to eq(-0.329)
              expect(results_forecast[:change_in_forecast_ordinary_income]).to eq(-0.354)
              expect(results_forecast[:change_in_forecast_net_income]).to eq(-0.359)
            end
          end
        end

        context '米国会計基準' do
          context "連結・第4四半期" do
            let(:xbrl) { Summary2.read doc("#{dir}/us-cons-2014-q4.htm") }
            let(:summary) { xbrl[:summary] }
            let(:results_forecast) { xbrl[:results_forecast].first }

            it do
              expect(summary[:code]).to eq '7203'
              expect(summary[:year]).to eq 2014
              expect(summary[:month]).to eq 3
              expect(summary[:quarter]).to eq 4
              expect(summary[:consolidation]).to eq(1)

              expect(summary[:net_sales]).to eq 25691911
              expect(summary[:operating_income]).to eq 2292112
              expect(summary[:ordinary_income]).to eq 2441080
              expect(summary[:net_income]).to eq 1823119
              expect(summary[:net_income_per_share]).to eq 575.30

              expect(summary[:change_in_net_sales]).to eq 0.164
              expect(summary[:change_in_operating_income]).to eq 0.735
              expect(summary[:change_in_ordinary_income]).to eq 0.739
              expect(summary[:change_in_net_income]).to eq 0.895

              expect(summary[:prior_net_sales]).to eq 22064192
              expect(summary[:prior_operating_income]).to eq 1320888
              expect(summary[:prior_ordinary_income]).to eq 1403649
              expect(summary[:prior_net_income]).to eq 962163
              expect(summary[:prior_net_income_per_share]).to eq 303.82

              expect(summary[:change_in_prior_net_sales]).to eq 0.187
              expect(summary[:change_in_prior_operating_income]).to eq 2.714
              expect(summary[:change_in_prior_ordinary_income]).to eq 2.243
              expect(summary[:change_in_prior_net_income]).to eq 2.393

              expect(results_forecast[:forecast_net_sales]).to eq 25700000
              expect(results_forecast[:forecast_operating_income]).to eq 2300000
              expect(results_forecast[:forecast_ordinary_income]).to eq 2390000
              expect(results_forecast[:forecast_net_income]).to eq 1780000
              expect(results_forecast[:forecast_net_income_per_share]).to eq 561.56

              expect(results_forecast[:change_in_forecast_net_sales]).to eq 0.0
              expect(results_forecast[:change_in_forecast_operating_income]).to eq 0.003
              expect(results_forecast[:change_in_forecast_ordinary_income]).to eq -0.021
              expect(results_forecast[:change_in_forecast_net_income]).to eq -0.024
            end
          end
        end

        context 'IFRS' do
          let(:xbrl) { Summary2.read doc("#{dir}/ifrs-cons-2013-q4.htm") }
          let(:summary) { xbrl[:summary] }
          let(:results_forecast) { xbrl[:results_forecast].first }

          it do
            expect(summary[:code]).to eq('8923')
            expect(summary[:year]).to eq(2013)
            expect(summary[:month]).to eq(11)
            expect(summary[:quarter]).to eq(4)
            expect(summary[:consolidation]).to eq(1)

            expect(summary[:net_sales]).to eq(35070)
            expect(summary[:operating_income]).to eq(3909)
            expect(summary[:ordinary_income]).to eq(3217)
            expect(summary[:net_income]).to eq(2003)
            expect(summary[:net_income_per_share]).to eq(42.99)

            expect(summary[:change_in_net_sales]).to eq(0.449)
            expect(summary[:change_in_operating_income]).to eq(0.369)
            expect(summary[:change_in_ordinary_income]).to eq(0.45)
            expect(summary[:change_in_net_income]).to eq(0.367)

            expect(summary[:prior_net_sales]).to eq(24195)
            expect(summary[:prior_operating_income]).to eq(2856)
            expect(summary[:prior_ordinary_income]).to eq(2218)
            expect(summary[:prior_net_income]).to eq(1465)
            expect(summary[:prior_net_income_per_share]).to eq(32.07)

#            expect(xbrl.change_in_prior_net_sales).to eq(0.008)
#            expect(xbrl.change_in_prior_operating_income).to eq(0.036)
#            expect(xbrl.change_in_prior_ordinary_income).to eq(0.039)
#            expect(xbrl.change_in_prior_net_income).to eq(0.287)

            expect(results_forecast[:forecast_net_sales]).to eq(41817)
            expect(results_forecast[:forecast_operating_income]).to eq(4618)
            expect(results_forecast[:forecast_ordinary_income]).to eq(3800)
            expect(results_forecast[:forecast_net_income]).to eq(2309)
            expect(results_forecast[:forecast_net_income_per_share]).to eq(47.82)

            expect(results_forecast[:change_in_forecast_net_sales]).to eq(0.192)
            expect(results_forecast[:change_in_forecast_operating_income]).to eq(0.181)
            expect(results_forecast[:change_in_forecast_ordinary_income]).to eq(0.181)
            expect(results_forecast[:change_in_forecast_net_income]).to eq(0.153)
          end
        end

        context 'Current-NetSalesで連結・非連結が取得できない' do
          let(:xbrl) { Summary2.read doc("#{dir}/current-net_sales-error.htm") }

          it do
            expect { xbrl }.not_to raise_error
          end
        end

        context 'NetSalesがない' do
          let(:xbrl) { Summary2.read doc("#{dir}/no-net_sales.htm") }

          it do
            expect { xbrl }.not_to raise_error
          end
        end
      end

      describe '.parse_company' do
        context '日本会計基準' do
          let(:xbrl) { Summary2.parse_company str("#{dir}/jp-cons-2014-q1.htm") }

          it do
            expect(xbrl.code).to eq "3046"
            expect(xbrl.company_name).to eq "株式会社 ジェイアイエヌ"
            expect(xbrl.consolidation).to eq 1
          end
        end
      end

    end
  end
end