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

      describe '.find_sector' do
        let(:context) { 'CurrentAccumulatedQ1ConsolidatedDuration' }

        context '一般商工業' do
          it do
            sector = Summary.send(:find_sector, doc("#{dir}/ja-cons-2013-q1.xbrl"), context)
            expect(sector).to eq(:general)
          end
        end

        context '銀行' do
          it do
            sector = Summary.send(:find_sector, doc("#{dir}/ja-bk-cons-2014-q1.xbrl"), context)
            expect(sector).to eq(:bank)
          end
        end
      end

      describe ".find_value" do
        context "要素が取得できない" do
          let(:doc) { double "doc", at_xpath: nil }

          it "nilを返す" do
            val = Summary.send(:find_value, doc, nil, nil)
            expect(val).to be_nil
          end
        end
      end

      describe ".parse" do
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