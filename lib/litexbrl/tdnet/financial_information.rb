module LiteXBRL
  module TDnet
    class FinancialInformation
      include Utils
      include AccountItem

      attr_accessor :code, :year, :month, :quarter

      # 名前空間
      NS = {
        'xbrli' => 'http://www.xbrl.org/2003/instance',
        'tse-t-ed' => 'http://www.xbrl.tdnet.info/jp/br/tdnet/t/ed/2007-06-30'
      }


      class << self

        private

        def read(doc)
          xbrl, accounting_base, context = find_base_data(doc)

          find_data(doc, xbrl, accounting_base, context)
        end

        #
        # contextを設定します
        #
        def context_hash(consolidation, season)
          raise StandardError.new("通期・四半期が設定されていません。") unless season

          year_duration = "Year#{consolidation}Duration"

          {
            context_duration: "Current#{season}#{consolidation}Duration",
            context_prior_duration: "Prior#{season}#{consolidation}Duration",
            context_instant: "Current#{season}#{consolidation}Instant",
            context_forecast: ->(quarter) { quarter == 4 ? "Next#{year_duration}" : "Current#{year_duration}"},
          }
        end

        #
        # 証券コードを取得します
        #
        def find_securities_code(doc, consolidation)
          elm_code = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentYear#{consolidation}Duration']/xbrli:entity/xbrli:identifier", NS)
          to_securities_code(elm_code)
        end

        #
        # 決算年を取得します
        #
        def find_year(doc, consolidation)
          elm_end = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentYear#{consolidation}Duration']/xbrli:period/xbrli:endDate", NS)
          to_year(elm_end)
        end

        #
        # 決算月を取得します
        #
        def find_month(doc, consolidation)
          elm_end = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentYear#{consolidation}Duration']/xbrli:period/xbrli:endDate", NS)
          to_month(elm_end)
        end

        #
        # 四半期を取得します
        #
        def find_quarter(doc, consolidation, context)
          elm_end = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentYear#{consolidation}Duration']/xbrli:period/xbrli:endDate", NS)
          elm_instant = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='#{context[:context_instant]}']/xbrli:period/xbrli:instant", NS)
          to_quarter(elm_end, elm_instant)
        end

        #
        # 決算短信サマリの勘定科目の値を取得します
        #
        def find_value_tse_t_ed(doc, item, context)
          find_value(doc, item, context) do |item, context|
            "//xbrli:xbrl/tse-t-ed:#{item}[@contextRef='#{context}']"
          end
        end

        #
        # 勘定科目の値を取得します
        #
        def find_value(doc, item, context)
          # 配列の場合、いずれかに該当するもの
          if item[0].is_a? String
            xpath = item.map {|item| yield(item, context) }.join('|')
            elm = doc.at_xpath xpath
            elm.content if elm
          # 2次元配列の場合、先頭の配列から優先に
          elsif item[0].is_a? Array
            item.each do |item|
              xpath = item.map {|item| yield(item, context) }.join('|')
              elm = doc.at_xpath xpath
              return elm.content if elm
            end

            nil # 該当なし
          end
        end
      end

      def attributes
        {
          code: code,
          year: year,
          month: month,
          quarter: quarter,
        }
      end

    end
  end
end