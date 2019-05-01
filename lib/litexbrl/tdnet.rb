require 'litexbrl/tdnet/account_item'
require 'litexbrl/tdnet/summary_attribute'
require 'litexbrl/tdnet/results_forecast_attribute'
require 'litexbrl/tdnet/company_attribute'
require 'litexbrl/tdnet/financial_information'
require 'litexbrl/tdnet/summary'
require 'litexbrl/tdnet/results_forecast'
require 'litexbrl/tdnet/financial_information2'
require 'litexbrl/tdnet/summary2'
require 'litexbrl/tdnet/results_forecast2'

module LiteXBRL
  module TDnet

    class << self

      def parse(path)
        doc = File.open(path) {|f| Nokogiri::XML f }
        read doc
      end

      def parse_string(str)
        doc = Nokogiri::XML str
        read doc
      end

      private

      def read(doc)
        document = find_reader doc

        document.read doc
      end

      def find_reader(doc)
        namespaces = doc.namespaces

        # TODO 委嬢する？
        if summary? namespaces
          Summary
        elsif summary2? namespaces
          Summary2
        elsif results_forecast? namespaces
          ResultsForecast
        elsif results_forecast2? namespaces
          ResultsForecast2
        else
          raise StandardError.new "ドキュメントがありません"
        end
      end

      def summary?(namespaces)
        namespaces.keys.any? {|ns| /tdnet-.+(jpsm|ussm|ifsm)/ =~ ns }
      end

      def summary2?(namespaces)
        namespaces.keys.any? {|ns| /tse-.+(jpsm|ussm|ifsm)/ =~ ns }
      end

      def results_forecast?(namespaces)
        namespaces.keys.any? {|ns| /tdnet-rvfc/ =~ ns }
      end

      def results_forecast2?(namespaces)
        namespaces.keys.any? {|ns| /tse-rvfc/ =~ ns }
      end

    end

  end
end