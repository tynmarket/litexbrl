require 'spec_helper'
require 'support/nokogiri_helper'

module LiteXBRL
  module TDnet
    describe CashFlow2 do
      include NokogiriHelper

      let(:dir) { File.expand_path '../../data/tdnet/cash_flow2', __FILE__ }

      describe ".read" do
        let(:xbrl) { CashFlow2.read doc("#{dir}/#{file}") }

        context '日本会計基準' do
          context "通期" do
            let(:file) { "jp_q4.htm" }

            it do
              expect(xbrl[:net_cash_provided_by_used_in_operating_activities]).to eq 4845
              expect(xbrl[:net_cash_provided_by_used_in_investment_activities]).to eq -8024
              expect(xbrl[:net_cash_provided_by_used_in_financing_activities]).to eq -1675
              expect(xbrl[:net_increase_decrease_in_cash_and_cash_equivalents]).to eq -5054
              expect(xbrl[:prior_cash_and_cash_equivalents]).to eq 23985
              expect(xbrl[:cash_and_cash_equivalents]).to eq 18930
            end
          end

          context "第3四半期" do
            let(:file) { "jp_q3.htm" }

            it do
              expect(xbrl[:net_cash_provided_by_used_in_operating_activities]).to eq 2406
              expect(xbrl[:net_cash_provided_by_used_in_investment_activities]).to eq -4664
              expect(xbrl[:net_cash_provided_by_used_in_financing_activities]).to eq -1672
              expect(xbrl[:net_increase_decrease_in_cash_and_cash_equivalents]).to eq -3844
              expect(xbrl[:prior_cash_and_cash_equivalents]).to eq 23985
              expect(xbrl[:cash_and_cash_equivalents]).to eq 20140
            end
          end
        end

        context 'IFRS' do
          context "通期" do
            let(:file) { "ifrs_q4.htm" }

            it do
              expect(xbrl[:net_cash_provided_by_used_in_operating_activities]).to eq 170233
              expect(xbrl[:net_cash_provided_by_used_in_investment_activities]).to eq -160844
              expect(xbrl[:net_cash_provided_by_used_in_financing_activities]).to eq -32683
              expect(xbrl[:net_increase_decrease_in_cash_and_cash_equivalents]).to eq -23680
              expect(xbrl[:prior_cash_and_cash_equivalents]).to eq 265947
              expect(xbrl[:cash_and_cash_equivalents]).to eq 242267
            end
          end
        end
      end

    end
  end
end