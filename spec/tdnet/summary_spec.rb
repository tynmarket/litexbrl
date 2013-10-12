require 'spec_helper'
require 'support/nokogiri_helper'

module LiteXBRL
  module TDnet
    describe Summary do
      include NokogiriHelper

      let(:dir) { File.expand_path '../../data/tdnet/summary', __FILE__ }

      describe ".find_consolidation" do
        it "連結" do
          consolidation = Summary.send(:find_consolidation, doc("#{dir}/ja-cons-2013-q1.xbrl"))
          expect(consolidation).to eq("Consolidated")
        end

        it "非連結" do
          consolidation = Summary.send(:find_consolidation, doc("#{dir}/ja-noncons-q1.xbrl"))
          expect(consolidation).to eq("NonConsolidated")
        end
      end

      describe ".find_season" do
        it "Q1" do
          season = Summary.send(:find_season, doc("#{dir}/ja-cons-2013-q1.xbrl"), "Consolidated")
          expect(season).to eq("AccumulatedQ1")
        end

        it "Q2" do
          season = Summary.send(:find_season, doc("#{dir}/ja-cons-2013-q2.xbrl"), "Consolidated")
          expect(season).to eq("AccumulatedQ2")
        end

        it "Q3" do
          season = Summary.send(:find_season, doc("#{dir}/ja-cons-2013-q3.xbrl"), "Consolidated")
          expect(season).to eq("AccumulatedQ3")
        end

        it "Q4" do
          season = Summary.send(:find_season, doc("#{dir}/ja-cons-2013-q4.xbrl"), "Consolidated")
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

      describe '.find_accounting_base' do
        context '日本会計基準' do
          it do
            accounting_base = Summary.send(:find_accounting_base, doc("#{dir}/ja-cons-2013-q1.xbrl"))
            expect(accounting_base).to eq(:jp)
          end
        end

        context '米国会計基準' do
          it do
            accounting_base = Summary.send(:find_accounting_base, doc("#{dir}/us-cons-2014-q1.xbrl"))
            expect(accounting_base).to eq(:us)
          end
        end

        context 'IFRS' do
          it do
            accounting_base = Summary.send(:find_accounting_base, doc("#{dir}/if-cons-2014-q1.xbrl"))
            expect(accounting_base).to eq(:if)
          end
        end
      end

      describe ".find_value" do
        context "要素が取得できない" do
          let(:doc) { double "doc", at_xpath: nil }
          let(:item) { ['NetSales'] }

          it "nilを返す" do
            val = Summary.send(:find_value, doc, item, nil)
            expect(val).to be_nil
          end
        end
      end

      describe ".parse" do
        context '日本会計基準' do
          context "連結・第1四半期" do
            let(:xbrl) { Summary.parse("#{dir}/ja-cons-2013-q1.xbrl") }

            it do
              expect(xbrl.code).to eq('4368')
              expect(xbrl.year).to eq(2013)
              expect(xbrl.quarter).to eq(1)

              expect(xbrl.net_sales).to eq(6818)
              expect(xbrl.operating_income).to eq(997)
              expect(xbrl.ordinary_income).to eq(957)
              expect(xbrl.net_income).to eq(543)
              expect(xbrl.net_income_per_share).to eq(86.21)
            end
          end

          context "連結・第2四半期" do
            let(:xbrl) { Summary.parse("#{dir}/ja-cons-2013-q2.xbrl") }

            it do
              expect(xbrl.code).to eq('4368')
              expect(xbrl.year).to eq(2013)
              expect(xbrl.quarter).to eq(2)

              expect(xbrl.net_sales).to eq(13740)
              expect(xbrl.operating_income).to eq(1863)
              expect(xbrl.ordinary_income).to eq(1777)
              expect(xbrl.net_income).to eq(1056)
              expect(xbrl.net_income_per_share).to eq(167.60)
            end
          end

          context "連結・第3四半期" do
            let(:xbrl) { Summary.parse("#{dir}/ja-cons-2013-q3.xbrl") }

            it do
              expect(xbrl.code).to eq('4368')
              expect(xbrl.year).to eq(2013)
              expect(xbrl.quarter).to eq(3)

              expect(xbrl.net_sales).to eq(20793)
              expect(xbrl.operating_income).to eq(2772)
              expect(xbrl.ordinary_income).to eq(2720)
              expect(xbrl.net_income).to eq(1655)
              expect(xbrl.net_income_per_share).to eq(262.79)
            end
          end

          context "連結・第4四半期" do
            let(:xbrl) { Summary.parse("#{dir}/ja-cons-2013-q4.xbrl") }

            it do
              expect(xbrl.code).to eq('4368')
              expect(xbrl.year).to eq(2013)
              expect(xbrl.quarter).to eq(4)

              expect(xbrl.net_sales).to eq(27355)
              expect(xbrl.operating_income).to eq(3223)
              expect(xbrl.ordinary_income).to eq(3231)
              expect(xbrl.net_income).to eq(1903)
              expect(xbrl.net_income_per_share).to eq(302.11)
            end
          end

          context "業種：銀行" do
            let(:xbrl) { Summary.parse("#{dir}/ja-bk-cons-2014-q1.xbrl") }

            it do
              expect(xbrl.code).to eq('8361')
              expect(xbrl.year).to eq(2014)
              expect(xbrl.quarter).to eq(1)

              expect(xbrl.net_sales).to eq(28278)
              expect(xbrl.operating_income).to eq(5079)
              expect(xbrl.ordinary_income).to eq(5079)
              expect(xbrl.net_income).to eq(4521)
              expect(xbrl.net_income_per_share).to eq(12.82)
            end
          end

          context '業種：証券' do
            let(:xbrl) { Summary.parse("#{dir}/ja-se-cons-2014-q1.xbrl") }

            it do
              expect(xbrl.code).to eq('8601')
              expect(xbrl.year).to eq(2014)
              expect(xbrl.quarter).to eq(1)

              expect(xbrl.net_sales).to eq(183082)
              expect(xbrl.operating_income).to eq(62307)
              expect(xbrl.ordinary_income).to eq(65087)
              expect(xbrl.net_income).to eq(57297)
              expect(xbrl.net_income_per_share).to eq(33.72)
            end
          end

          context '業種：保険' do
            let(:xbrl) { Summary.parse("#{dir}/ja-in-cons-2014-q1.xbrl") }

            it do
              expect(xbrl.code).to eq('8715')
              expect(xbrl.year).to eq(2014)
              expect(xbrl.quarter).to eq(1)

              expect(xbrl.net_sales).to eq(4394)
              expect(xbrl.operating_income).to eq(113)
              expect(xbrl.ordinary_income).to eq(113)
              expect(xbrl.net_income).to eq(68)
              expect(xbrl.net_income_per_share).to eq(3.96)
            end
          end

          context '業種：営業収益' do
            let(:xbrl) { Summary.parse("#{dir}/ja-oprv-cons-2014-q1.xbrl") }

            it do
              expect(xbrl.code).to eq('8289')
              expect(xbrl.year).to eq(2014)
              expect(xbrl.quarter).to eq(1)

              expect(xbrl.net_sales).to eq(24866)
              expect(xbrl.operating_income).to eq(117)
              expect(xbrl.ordinary_income).to eq(101)
              expect(xbrl.net_income).to eq(89)
              expect(xbrl.net_income_per_share).to eq(3.88)
            end
          end

          context '業種：営業収入' do
            let(:xbrl) { Summary.parse("#{dir}/ja-oprvsp-cons-2014-q1.xbrl") }

            it do
              expect(xbrl.code).to eq('9946')
              expect(xbrl.year).to eq(2014)
              expect(xbrl.quarter).to eq(1)

              expect(xbrl.net_sales).to eq(33307)
              expect(xbrl.operating_income).to eq(240)
              expect(xbrl.ordinary_income).to eq(563)
              expect(xbrl.net_income).to eq(113)
              expect(xbrl.net_income_per_share).to eq(3.92)
            end
          end

          context '業種：営業総収入' do
            let(:xbrl) { Summary.parse("#{dir}/ja-goprv-cons-2013-q4.xbrl") }

            it do
              expect(xbrl.code).to eq('8028')
              expect(xbrl.year).to eq(2013)
              expect(xbrl.quarter).to eq(4)

              expect(xbrl.net_sales).to eq(334087)
              expect(xbrl.operating_income).to eq(43107)
              expect(xbrl.ordinary_income).to eq(45410)
              expect(xbrl.net_income).to eq(25020)
              expect(xbrl.net_income_per_share).to eq(263.57)
            end
          end

          context '業種：完成工事高' do
            let(:xbrl) { Summary.parse("#{dir}/ja-nsco-cons-2013-q4.xbrl") }

            it do
              expect(xbrl.code).to eq('1861')
              expect(xbrl.year).to eq(2013)
              expect(xbrl.quarter).to eq(4)

              expect(xbrl.net_sales).to eq(260753)
              expect(xbrl.operating_income).to eq(-1167)
              expect(xbrl.ordinary_income).to eq(65)
              expect(xbrl.net_income).to eq(-1083)
              expect(xbrl.net_income_per_share).to eq(-5.91)
            end
          end
        end

        context '米国会計基準' do
          context '売上高：NetSales' do
            let(:xbrl) { Summary.parse("#{dir}/us-cons-2014-q1.xbrl") }

            it do
              expect(xbrl.code).to eq('7203')
              expect(xbrl.year).to eq(2014)
              expect(xbrl.quarter).to eq(1)

              expect(xbrl.net_sales).to eq(6255319)
              expect(xbrl.operating_income).to eq(663383)
              expect(xbrl.ordinary_income).to eq(724163)
              expect(xbrl.net_income).to eq(562194)
              expect(xbrl.net_income_per_share).to eq(177.45)
            end
          end

          context '売上高：OperatingRevenues' do
            let(:xbrl) { Summary.parse("#{dir}/us-oprv-cons-2014-q1.xbrl") }

            it do
              expect(xbrl.code).to eq('9432')
              expect(xbrl.year).to eq(2014)
              expect(xbrl.quarter).to eq(1)

              expect(xbrl.net_sales).to eq(2609117)
              expect(xbrl.operating_income).to eq(348926)
              expect(xbrl.ordinary_income).to eq(356084)
              expect(xbrl.net_income).to eq(166717)
              expect(xbrl.net_income_per_share).to eq(141.29)
            end
          end

          context '売上高：NetSalesAndOperatingRevenuesUS' do
            let(:xbrl) { Summary.parse("#{dir}/us-nsoprv-cons-2014-q1.xbrl") }

            it do
              expect(xbrl.code).to eq('6758')
              expect(xbrl.year).to eq(2014)
              expect(xbrl.quarter).to eq(1)

              expect(xbrl.net_sales).to eq(1712712)
              expect(xbrl.operating_income).to eq(36357)
              expect(xbrl.ordinary_income).to eq(46253)
              expect(xbrl.net_income).to eq(3480)
              expect(xbrl.net_income_per_share).to eq(3.44)
            end
          end

          context '売上高：TotalRevenuesUS' do
            let(:xbrl) { Summary.parse("#{dir}/us-tr-ibit-cons-2013-q4.xbrl") }

            it do
              expect(xbrl.code).to eq('8604')
              expect(xbrl.year).to eq(2013)
              expect(xbrl.quarter).to eq(4)

              expect(xbrl.net_sales).to eq(2079943)
              expect(xbrl.operating_income).to eq(237730)
              expect(xbrl.ordinary_income).to eq(237730)
              expect(xbrl.net_income).to eq(107234)
              expect(xbrl.net_income_per_share).to eq(29.04)
            end
          end

          context '営業利益：OperatingIncome' do
            let(:xbrl) { Summary.parse("#{dir}/us-oi-cons-2014-q1.xbrl") }

            it do
              expect(xbrl.code).to eq('6752')
              expect(xbrl.year).to eq(2014)
              expect(xbrl.quarter).to eq(1)

              expect(xbrl.net_sales).to eq(1824515)
              expect(xbrl.operating_income).to eq(64201)
              expect(xbrl.ordinary_income).to eq(122612)
              expect(xbrl.net_income).to eq(107831)
              expect(xbrl.net_income_per_share).to eq(46.65)
            end
          end

          context '営業利益：BasicNetIncomePerShareUS' do
            let(:xbrl) { Summary.parse("#{dir}/us-bnip-cons-2014-q1.xbrl") }

            it do
              expect(xbrl.code).to eq('7267')
              expect(xbrl.year).to eq(2014)
              expect(xbrl.quarter).to eq(1)

              expect(xbrl.net_sales).to eq(2834095)
              expect(xbrl.operating_income).to eq(184963)
              expect(xbrl.ordinary_income).to eq(172035)
              expect(xbrl.net_income).to eq(122499)
              expect(xbrl.net_income_per_share).to eq(67.97)
            end
          end

          context '営業利益：IncomeBeforeIncomeTaxesUS' do
            let(:xbrl) { Summary.parse("#{dir}/us-tr-ibit-cons-2013-q4.xbrl") }

            it do
              expect(xbrl.code).to eq('8604')
              expect(xbrl.year).to eq(2013)
              expect(xbrl.quarter).to eq(4)

              expect(xbrl.net_sales).to eq(2079943)
              expect(xbrl.operating_income).to eq(237730)
              expect(xbrl.ordinary_income).to eq(237730)
              expect(xbrl.net_income).to eq(107234)
              expect(xbrl.net_income_per_share).to eq(29.04)
            end
          end

          context '経常利益：IncomeFromContinuingOperationsBeforeIncomeTaxesUS' do
            let(:xbrl) { Summary.parse("#{dir}/us-ifco-cons-2013-q4.xbrl") }

            it do
              expect(xbrl.code).to eq('6502')
              expect(xbrl.year).to eq(2013)
              expect(xbrl.quarter).to eq(4)

              expect(xbrl.net_sales).to eq(5800281)
              expect(xbrl.operating_income).to eq(194316)
              expect(xbrl.ordinary_income).to eq(155553)
              expect(xbrl.net_income).to eq(77533)
              expect(xbrl.net_income_per_share).to eq(18.31)
            end
          end

          context '純利益：IncomeBeforeMinorityInterestUS' do
            let(:xbrl) { Summary.parse("#{dir}/us-ibmi-cons-2013-q4.xbrl") }

            it do
              expect(xbrl.code).to eq('6981')
              expect(xbrl.year).to eq(2013)
              expect(xbrl.quarter).to eq(4)

              expect(xbrl.net_sales).to eq(681021)
              expect(xbrl.operating_income).to eq(58636)
              expect(xbrl.ordinary_income).to eq(59534)
              expect(xbrl.net_income).to eq(42386)
              expect(xbrl.net_income_per_share).to eq(200.81)
            end
          end
        end

        context 'IFRS' do
          context '売上高：NetSalesIFRS' do
            let(:xbrl) { Summary.parse("#{dir}/if-cons-2014-q1.xbrl") }

            it do
              expect(xbrl.code).to eq('5202')
              expect(xbrl.year).to eq(2014)
              expect(xbrl.quarter).to eq(1)

              expect(xbrl.net_sales).to eq(150690)
              expect(xbrl.operating_income).to eq(-398)
              expect(xbrl.ordinary_income).to eq(-5364)
              expect(xbrl.net_income).to eq(-7112)
              expect(xbrl.net_income_per_share).to eq(-7.88)
            end
          end

          context '売上高：OperatingRevenuesIFRS、営業利益：ProfitBeforeTaxIFRS' do
            let(:xbrl) { Summary.parse("#{dir}/if-or-cons-2014-q1.xbrl") }

            it do
              expect(xbrl.code).to eq('8698')
              expect(xbrl.year).to eq(2014)
              expect(xbrl.quarter).to eq(1)

              expect(xbrl.net_sales).to eq(16866)
              expect(xbrl.operating_income).to eq(8407)
              expect(xbrl.ordinary_income).to eq(8407)
              expect(xbrl.net_income).to eq(5144)
              expect(xbrl.net_income_per_share).to eq(1751.61)
            end
          end

          context '売上高：SalesIFRS' do
            let(:xbrl) { Summary.parse("#{dir}/if-sa-cons-2014-q1.xbrl") }

            it do
              expect(xbrl.code).to eq('7741')
              expect(xbrl.year).to eq(2014)
              expect(xbrl.quarter).to eq(1)

              expect(xbrl.net_sales).to eq(100425)
              expect(xbrl.operating_income).to eq(20123)
              expect(xbrl.ordinary_income).to eq(20123)
              expect(xbrl.net_income).to eq(12302)
              expect(xbrl.net_income_per_share).to eq(28.51)
            end
          end
        end
      end

      describe ".parse_string" do
        let(:xbrl) { Summary.parse_string(File.read("#{dir}/ja-cons-2013-q1.xbrl")) }

        it do
          expect(xbrl.year).to eq(2013)
        end
      end

      describe "#attributes" do
        let(:summary) { Summary.new }
        let(:attr) { summary.attributes }

        it do
          summary.code = 1111
          summary.year = 2013
          summary.quarter = 1
          summary.net_sales = 100
          summary.operating_income = 10
          summary.ordinary_income = 11
          summary.net_income = 6
          summary.net_income_per_share = 123.1

          expect(attr[:code]).to eq(1111)
          expect(attr[:year]).to eq(2013)
          expect(attr[:quarter]).to eq(1)
          expect(attr[:net_sales]).to eq(100)
          expect(attr[:operating_income]).to eq(10)
          expect(attr[:ordinary_income]).to eq(11)
          expect(attr[:net_income]).to eq(6)
          expect(attr[:net_income_per_share]).to eq(123.1)
        end
      end

    end
  end
end