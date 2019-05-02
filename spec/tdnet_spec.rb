require 'spec_helper'
require 'support/nokogiri_helper'

module LiteXBRL
  describe TDnet do
    include NokogiriHelper

    let(:dir) { File.expand_path '../data/tdnet', __FILE__ }

    describe '.find_reader' do
      context 'Summary' do
        it do
          document = TDnet.send :find_reader, doc("#{dir}/summary.xbrl")
          expect(document).to eq(LiteXBRL::TDnet::Summary)
        end
      end

      context 'Summary2' do
        it do
          document = TDnet.send :find_reader, doc("#{dir}/summary2.htm")
          expect(document).to eq(LiteXBRL::TDnet::Summary2)
        end
      end

      context 'ResultsForecast' do
        it do
          document = TDnet.send :find_reader, doc("#{dir}/results_forecast.xbrl")
          expect(document).to eq(LiteXBRL::TDnet::ResultsForecast)
        end
      end

      context 'ResultsForecast2' do
        it do
          document = TDnet.send :find_reader, doc("#{dir}/results_forecast2.htm")
          expect(document).to eq(LiteXBRL::TDnet::ResultsForecast2)
        end
      end
    end

  end
end