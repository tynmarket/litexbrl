require 'spec_helper'
require 'support/nokogiri_helper'

module LiteXBRL
  module TDnet
    describe Summary do
      include NokogiriHelper

      let(:dir) { File.expand_path '../../data/tdnet/summary', __FILE__ }

      describe ".find_consolidation" do
        it "非連結" do
          consolidation = Summary.send(:find_consolidation, doc("#{dir}/jp-noncons-q1.xbrl"))
          expect(consolidation).to eq("NonConsolidated")
        end
      end

      describe ".find_season" do
        it "Q1" do
          season = Summary.send(:find_season, doc("#{dir}/jp-cons-2013-q1.xbrl"), "Consolidated")
          expect(season).to eq("AccumulatedQ1")
        end

        it "Q2" do
          season = Summary.send(:find_season, doc("#{dir}/jp-cons-2013-q2.xbrl"), "Consolidated")
          expect(season).to eq("AccumulatedQ2")
        end

        it "Q3" do
          season = Summary.send(:find_season, doc("#{dir}/jp-cons-2013-q3.xbrl"), "Consolidated")
          expect(season).to eq("AccumulatedQ3")
        end

        it "Q4" do
          season = Summary.send(:find_season, doc("#{dir}/jp-cons-2013-q4.xbrl"), "Consolidated")
          expect(season).to eq("Year")
        end
      end

      describe ".context_hash" do
        let(:consolidation) { 'Consolidated' }
        let(:season) { 'AccumulatedQ1' }

        it "context" do
          context_hash = Summary.send(:context_hash, consolidation, season)

          expect(context_hash[:context_duration]).to eq('CurrentAccumulatedQ1ConsolidatedDuration')
          expect(context_hash[:context_instant]).to eq('CurrentAccumulatedQ1ConsolidatedInstant')
        end
      end

      describe ".find_value_tse_t_ed" do
        context "要素が取得できない" do
          let(:doc) { double "doc", at_xpath: nil }
          let(:item) { ['NetSales'] }

          it "nilを返す" do
            val = Summary.send(:find_value_tse_t_ed, doc, item, nil)
            expect(val).to be_nil
          end
        end
      end

      describe ".read doc" do
        context '日本会計基準' do
          context "連結・第1四半期" do
            let(:xbrl) { Summary.read doc("#{dir}/jp-cons-2013-q1.xbrl") }
            let(:summary) { xbrl[:summary] }
            let(:results_forecast) { xbrl[:results_forecast].first }

            it do
              expect(summary[:code]).to eq('4368')
              expect(summary[:year]).to eq(2013)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(1)

              expect(summary[:net_sales]).to eq(6818)
              expect(summary[:operating_income]).to eq(997)
              expect(summary[:ordinary_income]).to eq(957)
              expect(summary[:net_income]).to eq(543)
              expect(summary[:net_income_per_share]).to eq(86.21)

              expect(summary[:change_in_net_sales]).to eq(-0.118)
              expect(summary[:change_in_operating_income]).to eq(-0.225)
              expect(summary[:change_in_ordinary_income]).to eq(-0.222)
              expect(summary[:change_in_net_income]).to eq(-0.545)

              expect(summary[:prior_net_sales]).to eq(7727)
              expect(summary[:prior_operating_income]).to eq(1287)
              expect(summary[:prior_ordinary_income]).to eq(1230)
              expect(summary[:prior_net_income]).to eq(1192)
              expect(summary[:prior_net_income_per_share]).to eq(189.29)

              expect(summary[:change_in_prior_net_sales]).to eq(0.03)
              expect(summary[:change_in_prior_operating_income]).to eq(0.117)
              expect(summary[:change_in_prior_ordinary_income]).to eq(0.186)
              expect(summary[:change_in_prior_net_income]).to eq 0.947

              expect(results_forecast[:forecast_net_sales]).to eq(30000)
              expect(results_forecast[:forecast_operating_income]).to eq(3700)
              expect(results_forecast[:forecast_ordinary_income]).to eq(3600)
              expect(results_forecast[:forecast_net_income]).to eq(2000)
              expect(results_forecast[:forecast_net_income_per_share]).to eq(317.4)

              expect(results_forecast[:change_in_forecast_net_sales]).to eq(0.062)
              expect(results_forecast[:change_in_forecast_operating_income]).to eq(-0.053)
              expect(results_forecast[:change_in_forecast_ordinary_income]).to eq(-0.059)
              expect(results_forecast[:change_in_forecast_net_income]).to eq(-0.203)
            end
          end

          context "連結・第2四半期" do
            let(:xbrl) { Summary.read doc("#{dir}/jp-cons-2013-q2.xbrl") }
            let(:summary) { xbrl[:summary] }
            let(:results_forecast) { xbrl[:results_forecast].first }

            it do
              expect(summary[:code]).to eq('4368')
              expect(summary[:year]).to eq(2013)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(2)

              expect(summary[:net_sales]).to eq(13740)
              expect(summary[:operating_income]).to eq(1863)
              expect(summary[:ordinary_income]).to eq(1777)
              expect(summary[:net_income]).to eq(1056)
              expect(summary[:net_income_per_share]).to eq(167.60)
              expect(results_forecast[:forecast_net_sales]).to eq(30000)
              expect(results_forecast[:forecast_operating_income]).to eq(3700)
              expect(results_forecast[:forecast_ordinary_income]).to eq(3600)
              expect(results_forecast[:forecast_net_income]).to eq(2000)
              expect(results_forecast[:forecast_net_income_per_share]).to eq(317.4)
            end
          end

          context "連結・第3四半期" do
            let(:xbrl) { Summary.read doc("#{dir}/jp-cons-2013-q3.xbrl") }
            let(:summary) { xbrl[:summary] }
            let(:results_forecast) { xbrl[:results_forecast].first }

            it do
              expect(summary[:code]).to eq('4368')
              expect(summary[:year]).to eq(2013)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(3)

              expect(summary[:net_sales]).to eq(20793)
              expect(summary[:operating_income]).to eq(2772)
              expect(summary[:ordinary_income]).to eq(2720)
              expect(summary[:net_income]).to eq(1655)
              expect(summary[:net_income_per_share]).to eq(262.79)
              expect(results_forecast[:forecast_net_sales]).to eq(30000)
              expect(results_forecast[:forecast_operating_income]).to eq(3700)
              expect(results_forecast[:forecast_ordinary_income]).to eq(3600)
              expect(results_forecast[:forecast_net_income]).to eq(2000)
              expect(results_forecast[:forecast_net_income_per_share]).to eq(317.4)
            end
          end

          context "連結・第4四半期" do
            let(:xbrl) { Summary.read doc("#{dir}/jp-cons-2013-q4.xbrl") }
            let(:summary) { xbrl[:summary] }
            let(:results_forecast) { xbrl[:results_forecast].first }

            it do
              expect(summary[:code]).to eq('4368')
              expect(summary[:year]).to eq(2013)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(4)

              expect(summary[:net_sales]).to eq(27355)
              expect(summary[:operating_income]).to eq(3223)
              expect(summary[:ordinary_income]).to eq(3231)
              expect(summary[:net_income]).to eq(1903)
              expect(summary[:net_income_per_share]).to eq(302.11)

              expect(summary[:change_in_net_sales]).to eq(-0.032)
              expect(summary[:change_in_operating_income]).to eq(-0.175)
              expect(summary[:change_in_ordinary_income]).to eq(-0.155)
              expect(summary[:change_in_net_income]).to eq(-0.241)

              expect(summary[:prior_net_sales]).to eq(28247)
              expect(summary[:prior_operating_income]).to eq(3908)
              expect(summary[:prior_ordinary_income]).to eq(3826)
              expect(summary[:prior_net_income]).to eq(2508)
              expect(summary[:prior_net_income_per_share]).to eq(398.04)

              expect(summary[:change_in_prior_net_sales]).to eq -0.066
              expect(summary[:change_in_prior_operating_income]).to eq -0.157
              expect(summary[:change_in_prior_ordinary_income]).to eq -0.122
              expect(summary[:change_in_prior_net_income]).to eq 0.076

              expect(results_forecast[:forecast_net_sales]).to eq(30000)
              expect(results_forecast[:forecast_operating_income]).to eq(3500)
              expect(results_forecast[:forecast_ordinary_income]).to eq(3400)
              expect(results_forecast[:forecast_net_income]).to eq(2000)
              expect(results_forecast[:forecast_net_income_per_share]).to eq(317.4)

              expect(results_forecast[:change_in_forecast_net_sales]).to eq(0.097)
              expect(results_forecast[:change_in_forecast_operating_income]).to eq(0.086)
              expect(results_forecast[:change_in_forecast_ordinary_income]).to eq(0.052)
              expect(results_forecast[:change_in_forecast_net_income]).to eq(0.051)
            end
          end

          context "業種：銀行" do
            let(:xbrl) { Summary.read doc("#{dir}/jp-bk-cons-2014-q1.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('8361')
              expect(summary[:year]).to eq(2014)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(1)

              expect(summary[:net_sales]).to eq(28278)
              expect(summary[:operating_income]).to eq(5079)
              expect(summary[:ordinary_income]).to eq(5079)
              expect(summary[:net_income]).to eq(4521)
              expect(summary[:net_income_per_share]).to eq(12.82)
            end
          end

          context '業種：証券' do
            let(:xbrl) { Summary.read doc("#{dir}/jp-se-cons-2014-q1.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('8601')
              expect(summary[:year]).to eq(2014)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(1)

              expect(summary[:net_sales]).to eq(183082)
              expect(summary[:operating_income]).to eq(62307)
              expect(summary[:ordinary_income]).to eq(65087)
              expect(summary[:net_income]).to eq(57297)
              expect(summary[:net_income_per_share]).to eq(33.72)
            end
          end

          context '業種：保険' do
            let(:xbrl) { Summary.read doc("#{dir}/jp-in-cons-2014-q1.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('8715')
              expect(summary[:year]).to eq(2014)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(1)

              expect(summary[:net_sales]).to eq(4394)
              expect(summary[:operating_income]).to eq(113)
              expect(summary[:ordinary_income]).to eq(113)
              expect(summary[:net_income]).to eq(68)
              expect(summary[:net_income_per_share]).to eq(3.96)
            end
          end

          context '業種：営業収益' do
            let(:xbrl) { Summary.read doc("#{dir}/jp-oprv-cons-2014-q1.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('8289')
              expect(summary[:year]).to eq(2014)
              expect(summary[:month]).to eq(2)
              expect(summary[:quarter]).to eq(1)

              expect(summary[:net_sales]).to eq(24866)
              expect(summary[:operating_income]).to eq(117)
              expect(summary[:ordinary_income]).to eq(101)
              expect(summary[:net_income]).to eq(89)
              expect(summary[:net_income_per_share]).to eq(3.88)
            end
          end

          context '業種：営業収入' do
            let(:xbrl) { Summary.read doc("#{dir}/jp-oprvsp-cons-2014-q1.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('9946')
              expect(summary[:year]).to eq(2014)
              expect(summary[:month]).to eq(2)
              expect(summary[:quarter]).to eq(1)

              expect(summary[:net_sales]).to eq(33307)
              expect(summary[:operating_income]).to eq(240)
              expect(summary[:ordinary_income]).to eq(563)
              expect(summary[:net_income]).to eq(113)
              expect(summary[:net_income_per_share]).to eq(3.92)
            end
          end

          context '業種：営業総収入' do
            let(:xbrl) { Summary.read doc("#{dir}/jp-goprv-cons-2013-q4.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('8028')
              expect(summary[:year]).to eq(2013)
              expect(summary[:month]).to eq(2)
              expect(summary[:quarter]).to eq(4)

              expect(summary[:net_sales]).to eq(334087)
              expect(summary[:operating_income]).to eq(43107)
              expect(summary[:ordinary_income]).to eq(45410)
              expect(summary[:net_income]).to eq(25020)
              expect(summary[:net_income_per_share]).to eq(263.57)
            end
          end

          context '業種：完成工事高' do
            let(:xbrl) { Summary.read doc("#{dir}/jp-nsco-cons-2013-q4.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('1861')
              expect(summary[:year]).to eq(2013)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(4)

              expect(summary[:net_sales]).to eq(260753)
              expect(summary[:operating_income]).to eq(-1167)
              expect(summary[:ordinary_income]).to eq(65)
              expect(summary[:net_income]).to eq(-1083)
              expect(summary[:net_income_per_share]).to eq(-5.91)
            end
          end
        end

        context '米国会計基準' do
          context '売上高：NetSales' do
            let(:xbrl) { Summary.read doc("#{dir}/us-cons-2014-q1.xbrl") }
            let(:summary) { xbrl[:summary] }
            let(:results_forecast) { xbrl[:results_forecast].first }

            it do
              expect(summary[:code]).to eq('7203')
              expect(summary[:year]).to eq(2014)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(1)

              expect(summary[:net_sales]).to eq(6255319)
              expect(summary[:operating_income]).to eq(663383)
              expect(summary[:ordinary_income]).to eq(724163)
              expect(summary[:net_income]).to eq(562194)
              expect(summary[:net_income_per_share]).to eq(177.45)

              expect(summary[:change_in_net_sales]).to eq 0.137
              expect(summary[:change_in_operating_income]).to eq 0.879
              expect(summary[:change_in_ordinary_income]).to eq 0.744
              expect(summary[:change_in_net_income]).to eq 0.936

              expect(summary[:prior_net_sales]).to eq 5501573
              expect(summary[:prior_operating_income]).to eq 353143
              expect(summary[:prior_ordinary_income]).to eq 415203
              expect(summary[:prior_net_income]).to eq 290347
              expect(summary[:prior_net_income_per_share]).to eq 91.68

              expect(summary[:change_in_prior_net_sales]).to eq 0.599
#              expect(summary[:change_in_prior_operating_income]).to eq -0.157
#              expect(summary[:change_in_prior_ordinary_income]).to eq -0.122
#              expect(summary[:change_in_prior_net_income]).to eq 0.076

              expect(results_forecast[:forecast_net_sales]).to eq(24000000)
              expect(results_forecast[:forecast_operating_income]).to eq(1940000)
              expect(results_forecast[:forecast_ordinary_income]).to eq(2030000)
              expect(results_forecast[:forecast_net_income]).to eq(1480000)
              expect(results_forecast[:forecast_net_income_per_share]).to eq(467.09)

              expect(results_forecast[:change_in_forecast_net_sales]).to eq 0.088
              expect(results_forecast[:change_in_forecast_operating_income]).to eq 0.469
              expect(results_forecast[:change_in_forecast_ordinary_income]).to eq 0.446
              expect(results_forecast[:change_in_forecast_net_income]).to eq 0.538
            end
          end

          context '売上高：OperatingRevenues' do
            let(:xbrl) { Summary.read doc("#{dir}/us-oprv-cons-2014-q1.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('9432')
              expect(summary[:year]).to eq(2014)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(1)

              expect(summary[:net_sales]).to eq(2609117)
              expect(summary[:operating_income]).to eq(348926)
              expect(summary[:ordinary_income]).to eq(356084)
              expect(summary[:net_income]).to eq(166717)
              expect(summary[:net_income_per_share]).to eq(141.29)
            end
          end

          context '売上高：NetSalesAndOperatingRevenuesUS' do
            let(:xbrl) { Summary.read doc("#{dir}/us-nsoprv-cons-2014-q1.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('6758')
              expect(summary[:year]).to eq(2014)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(1)

              expect(summary[:net_sales]).to eq(1712712)
              expect(summary[:operating_income]).to eq(36357)
              expect(summary[:ordinary_income]).to eq(46253)
              expect(summary[:net_income]).to eq(3480)
              expect(summary[:net_income_per_share]).to eq(3.44)
            end
          end

          context '売上高：TotalRevenuesUS' do
            let(:xbrl) { Summary.read doc("#{dir}/us-tr-ibit-cons-2013-q4.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('8604')
              expect(summary[:year]).to eq(2013)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(4)

              expect(summary[:net_sales]).to eq(2079943)
              expect(summary[:operating_income]).to eq(237730)
              expect(summary[:ordinary_income]).to eq(237730)
              expect(summary[:net_income]).to eq(107234)
              expect(summary[:net_income_per_share]).to eq(29.04)
            end
          end

          context '営業利益：OperatingIncome' do
            let(:xbrl) { Summary.read doc("#{dir}/us-oi-cons-2014-q1.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('6752')
              expect(summary[:year]).to eq(2014)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(1)

              expect(summary[:net_sales]).to eq(1824515)
              expect(summary[:operating_income]).to eq(64201)
              expect(summary[:ordinary_income]).to eq(122612)
              expect(summary[:net_income]).to eq(107831)
              expect(summary[:net_income_per_share]).to eq(46.65)
            end
          end

          context '営業利益：BasicNetIncomePerShareUS' do
            let(:xbrl) { Summary.read doc("#{dir}/us-bnip-cons-2014-q1.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('7267')
              expect(summary[:year]).to eq(2014)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(1)

              expect(summary[:net_sales]).to eq(2834095)
              expect(summary[:operating_income]).to eq(184963)
              expect(summary[:ordinary_income]).to eq(172035)
              expect(summary[:net_income]).to eq(122499)
              expect(summary[:net_income_per_share]).to eq(67.97)
            end
          end

          context '営業利益：IncomeBeforeIncomeTaxesUS' do
            let(:xbrl) { Summary.read doc("#{dir}/us-tr-ibit-cons-2013-q4.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('8604')
              expect(summary[:year]).to eq(2013)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(4)

              expect(summary[:net_sales]).to eq(2079943)
              expect(summary[:operating_income]).to eq(237730)
              expect(summary[:ordinary_income]).to eq(237730)
              expect(summary[:net_income]).to eq(107234)
              expect(summary[:net_income_per_share]).to eq(29.04)
            end
          end

          context '経常利益：IncomeFromContinuingOperationsBeforeIncomeTaxesUS' do
            let(:xbrl) { Summary.read doc("#{dir}/us-ifco-cons-2013-q4.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('6502')
              expect(summary[:year]).to eq(2013)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(4)

              expect(summary[:net_sales]).to eq(5800281)
              expect(summary[:operating_income]).to eq(194316)
              expect(summary[:ordinary_income]).to eq(155553)
              expect(summary[:net_income]).to eq(77533)
              expect(summary[:net_income_per_share]).to eq(18.31)
            end
          end

          context '純利益：IncomeBeforeMinorityInterestUS' do
            let(:xbrl) { Summary.read doc("#{dir}/us-ibmi-cons-2013-q4.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('6981')
              expect(summary[:year]).to eq(2013)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(4)

              expect(summary[:net_sales]).to eq(681021)
              expect(summary[:operating_income]).to eq(58636)
              expect(summary[:ordinary_income]).to eq(59534)
              expect(summary[:net_income]).to eq(42386)
              expect(summary[:net_income_per_share]).to eq(200.81)
            end
          end
        end

        context 'IFRS' do
          context '売上高：NetSalesIFRS' do
            let(:xbrl) { Summary.read doc("#{dir}/ifrs-cons-2014-q1.xbrl") }
            let(:summary) { xbrl[:summary] }
            let(:results_forecast) { xbrl[:results_forecast].first }

            it do
              expect(summary[:code]).to eq('5202')
              expect(summary[:year]).to eq(2014)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(1)

              expect(summary[:net_sales]).to eq(150690)
              expect(summary[:operating_income]).to eq(-398)
              expect(summary[:ordinary_income]).to eq(-5364)
              expect(summary[:net_income]).to eq(-7112)
              expect(summary[:net_income_per_share]).to eq(-7.88)

              expect(summary[:change_in_net_sales]).to eq 0.148
#              expect(summary[:change_in_operating_income]).to eq 0.879
#              expect(summary[:change_in_ordinary_income]).to eq 0.744
#              expect(summary[:change_in_net_income]).to eq 0.936

              expect(summary[:prior_net_sales]).to eq 131221
              expect(summary[:prior_operating_income]).to eq -8509
              expect(summary[:prior_ordinary_income]).to eq -12181
              expect(summary[:prior_net_income]).to eq -11123
              expect(summary[:prior_net_income_per_share]).to eq -12.33

              expect(summary[:change_in_prior_net_sales]).to eq -0.096
#              expect(summary[:change_in_prior_operating_income]).to eq -0.157
#              expect(summary[:change_in_prior_ordinary_income]).to eq -0.122
#              expect(summary[:change_in_prior_net_income]).to eq 0.076

              expect(results_forecast[:forecast_net_sales]).to eq(600000)
              expect(results_forecast[:forecast_operating_income]).to eq(3000)
              expect(results_forecast[:forecast_ordinary_income]).to eq(-15000) # ForecastProfitBeforeIncomeTaxIFRS
              expect(results_forecast[:forecast_net_income]).to eq(-21000)
              expect(results_forecast[:forecast_net_income_per_share]).to eq(-23.27)  # ForecastBasicEarningPerShareIFRS

              expect(results_forecast[:change_in_forecast_net_sales]).to eq 0.151
#              expect(results_forecast[:change_in_forecast_operating_income]).to eq 0.469
#              expect(results_forecast[:change_in_forecast_ordinary_income]).to eq 0.446
#              expect(results_forecast[:change_in_forecast_net_income]).to eq 0.538
            end
          end

          context '売上高：OperatingRevenuesIFRS、営業利益：ProfitBeforeTaxIFRS' do
            let(:xbrl) { Summary.read doc("#{dir}/ifrs-or-cons-2014-q1.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('8698')
              expect(summary[:year]).to eq(2014)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(1)

              expect(summary[:net_sales]).to eq(16866)
              expect(summary[:operating_income]).to eq(8407)
              expect(summary[:ordinary_income]).to eq(8407)
              expect(summary[:net_income]).to eq(5144)
              expect(summary[:net_income_per_share]).to eq(1751.61)
              # TODO 業績予想のテスト追加
            end
          end

          context '売上高：SalesIFRS' do
            let(:xbrl) { Summary.read doc("#{dir}/ifrs-sa-cons-2014-q1.xbrl") }
            let(:summary) { xbrl[:summary] }

            it do
              expect(summary[:code]).to eq('7741')
              expect(summary[:year]).to eq(2014)
              expect(summary[:month]).to eq(3)
              expect(summary[:quarter]).to eq(1)

              expect(summary[:net_sales]).to eq(100425)
              expect(summary[:operating_income]).to eq(20123)
              expect(summary[:ordinary_income]).to eq(20123)
              expect(summary[:net_income]).to eq(12302)
              expect(summary[:net_income_per_share]).to eq(28.51)
              # TODO 業績予想のテスト追加
            end
          end
        end
      end

    end
  end
end