require 'spec_helper'

module LiteXBRL
  module TDnet
    describe AccountItem do
=begin
      describe '.define_item' do
        let(:items) { {jp: ['NetSales'], if: ['NetSalesIFRS']} }

        context '文字列' do
          it do
            created = AccountItem.define_item(items) {|item| "ChangeIn#{item}" }

            expect(created[:jp]).to eq(['ChangeInNetSales'])
            expect(created[:if]).to eq(['ChangeInNetSalesIFRS'])
          end
        end

        context 'ハッシュ' do
          it do
            created = AccountItem.define_item(items) do |item|
              {jp: "ChangeIn#{item}", us: "ChangeIn#{item}", :if => ["ChangeIn#{item}", "ChangesIn#{item}"]}
            end

            expect(created[:jp]).to eq(['ChangeInNetSales'])
            expect(created[:if]).to eq(['ChangeInNetSalesIFRS', 'ChangesInNetSalesIFRS'])
          end
        end
      end

      describe '.define_nested_item' do
        let(:items) { {jp: [['NetSales'], ['NetSales2']], :if => [['NetSalesIFRS']]} }

        context '文字列' do
          it do
            created = AccountItem.define_nested_item(items) {|item| "ChangeIn#{item}" }

            expect(created[:jp]).to eq([['ChangeInNetSales'], ['ChangeInNetSales2']])
            expect(created[:if]).to eq([['ChangeInNetSalesIFRS']])
          end
        end

        context 'ハッシュ' do
          it do
            created = AccountItem.define_nested_item(items) do |item|
              {jp: "ChangeIn#{item}", us: "ChangeIn#{item}", :if => ["ChangeIn#{item}", "ChangesIn#{item}"]}
            end

            expect(created[:jp]).to eq([['ChangeInNetSales'], ['ChangeInNetSales2']])
            expect(created[:if]).to eq([['ChangeInNetSalesIFRS', 'ChangesInNetSalesIFRS']])
          end
        end
      end
=end
    end
  end
end