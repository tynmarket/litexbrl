module LiteXBRL
  module TDnet
    class Summary2
      include Utils
      include AccountItem

      attr_accessor :code, :year, :month, :quarter

      attr_accessor :net_sales, :operating_income, :ordinary_income, :net_income, :net_income_per_share,
        :forecast_net_sales, :forecast_operating_income, :forecast_ordinary_income, :forecast_net_income, :forecast_net_income_per_share

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
          xbrl, accounting_base, context = find_base_data(doc)

          find_data(doc, xbrl, accounting_base, context)
        end

        def find_base_data(doc)
          season = find_season(doc)
          consolidation = find_consolidation(doc, season)
          context = context_hash(consolidation, season)

          xbrl = new

          # 証券コード
          xbrl.code = find_securities_code(doc, season)
          # 決算年・決算月
          xbrl.year, xbrl.month = find_year_and_month(doc)
          # 四半期
          xbrl.quarter = to_quarter2(season)

          # 会計基準
          accounting_base = find_accounting_base(doc, context, xbrl.quarter)

          return xbrl, accounting_base, context
        end

=begin
        def find_data(doc, xbrl, accounting_base, context)
          # 売上高
          xbrl.net_sales = to_mill(find_value_tse_ed_t(doc, NET_SALES[accounting_base], context[:context_duration]))
          # 営業利益
          xbrl.operating_income = to_mill(find_value_tse_ed_t(doc, OPERATING_INCOME[accounting_base], context[:context_duration]))
          # 経常利益
          xbrl.ordinary_income = to_mill(find_value_tse_ed_t(doc, ORDINARY_INCOME[accounting_base], context[:context_duration]))
          # 純利益
          xbrl.net_income = to_mill(find_value_tse_ed_t(doc, NET_INCOME[accounting_base], context[:context_duration]))
          # 1株当たり純利益
          xbrl.net_income_per_share = to_f(find_value_tse_ed_t(doc, NET_INCOME_PER_SHARE[accounting_base], context[:context_duration]))

          # 通期予想売上高
          xbrl.forecast_net_sales = to_mill(find_value_tse_ed_t(doc, NET_SALES[accounting_base], context[:context_forecast].call(xbrl.quarter)))
          # 通期予想営業利益
          xbrl.forecast_operating_income = to_mill(find_value_tse_ed_t(doc, OPERATING_INCOME[accounting_base], context[:context_forecast].call(xbrl.quarter)))
          # 通期予想経常利益
          xbrl.forecast_ordinary_income = to_mill(find_value_tse_ed_t(doc, ORDINARY_INCOME[accounting_base], context[:context_forecast].call(xbrl.quarter)))
          # 通期予想純利益
          xbrl.forecast_net_income = to_mill(find_value_tse_ed_t(doc, NET_INCOME[accounting_base], context[:context_forecast].call(xbrl.quarter)))
          # 通期予想1株当たり純利益
          xbrl.forecast_net_income_per_share = to_f(find_value_tse_ed_t(doc, NET_INCOME_PER_SHARE[accounting_base], context[:context_forecast].call(xbrl.quarter)))

          xbrl
        end
=end
        #
        # 通期・四半期を取得します
        #
        def find_season(doc)
          q1 = doc.at_xpath("//ix:nonNumeric[@contextRef='CurrentAccumulatedQ1Instant' and @name='tse-ed-t:SecuritiesCode']")
          q2 = doc.at_xpath("//ix:nonNumeric[@contextRef='CurrentAccumulatedQ2Instant' and @name='tse-ed-t:SecuritiesCode']")
          q3 = doc.at_xpath("//ix:nonNumeric[@contextRef='CurrentAccumulatedQ3Instant' and @name='tse-ed-t:SecuritiesCode']")
          year = doc.at_xpath("//ix:nonNumeric[@contextRef='CurrentYearInstant' and @name='tse-ed-t:SecuritiesCode']")

          if q1
            "AccumulatedQ1"
          elsif q2
            "AccumulatedQ2"
          elsif q3
            "AccumulatedQ3"
          elsif year
            "Year"
          else
            raise Exception.new("通期・四半期を取得出来ません。")
          end
        end

        #
        # 連結・非連結を取得します
        #
        def find_consolidation(doc, season)
          cons = doc.at_xpath("//ix:nonFraction[@contextRef='Current#{season}Duration_ConsolidatedMember_ResultMember' and @name='tse-ed-t:NetSales']")
          non_cons = doc.at_xpath("//ix:nonFraction[@contextRef='Current#{season}Duration_NonConsolidatedMember_ResultMember' and @name='tse-ed-t:NetSales']")

          if cons
            "Consolidated"
          elsif non_cons
            "NonConsolidated"
          else
            raise Exception.new("連結・非連結ともに該当しません。")
          end
        end

        #
        # contextを設定します
        #
        def context_hash(consolidation, season)
          year_duration = "YearDuration_#{consolidation}Member_ForecastMember"

          {
            context_duration: "Current#{season}Duration_#{consolidation}Member_ResultMember",
            context_instant: "Current#{season}#{consolidation}Instant",
            context_forecast: ->(quarter) { quarter == 4 ? "Next#{year_duration}" : "Current#{year_duration}"},
          }
        end

        #
        # 証券コードを取得します
        #
        def find_securities_code(doc, season)
          elm_code = doc.at_xpath("//ix:nonNumeric[@contextRef='Current#{season}Instant' and @name='tse-ed-t:SecuritiesCode']")
          to_securities_code(elm_code)
        end

        #
        # 決算年・決算月を取得します
        #
        def find_year_and_month(doc)
          elm_end = doc.at_xpath("//xbrli:context[@id='CurrentYearDuration']/xbrli:period/xbrli:endDate")
          return to_year(elm_end), to_month(elm_end)
        end

        #
        # 会計基準を取得します
        #
        def find_accounting_base(doc, context, quarter)
          namespace = doc.namespaces.keys.find {|ns| ns.start_with?('xmlns:tse-qced') || ns.start_with?('xmlns:tse-aced') }

          case namespace
          when /.+jpsm.+/
            :jp
          when /.+ussm.+/
            :us
          when /.+ifsm.+/
            :if
          else
            raise Exception.new("会計基準を取得出来ません。")
          end
        end

        #
        # 決算短信サマリの勘定科目の値を取得します
        #
        def find_value_tse_ed_t(doc, item, context)
          find_value(doc, item, context) do |item, context|
            "//ix:nonFraction[@contextRef='#{context}' and @name='tse-ed-t:#{item}']"
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

      def self.find_data(doc, xbrl, accounting_base, context)
        # 売上高
        xbrl.net_sales = to_mill(find_value_tse_ed_t(doc, NET_SALES[accounting_base], context[:context_duration]))
        # 営業利益
        xbrl.operating_income = to_mill(find_value_tse_ed_t(doc, OPERATING_INCOME[accounting_base], context[:context_duration]))
        # 経常利益
        xbrl.ordinary_income = to_mill(find_value_tse_ed_t(doc, ORDINARY_INCOME[accounting_base], context[:context_duration]))
        # 純利益
        xbrl.net_income = to_mill(find_value_tse_ed_t(doc, NET_INCOME[accounting_base], context[:context_duration]))
        # 1株当たり純利益
        xbrl.net_income_per_share = to_f(find_value_tse_ed_t(doc, NET_INCOME_PER_SHARE[accounting_base], context[:context_duration]))

        # 通期予想売上高
        xbrl.forecast_net_sales = to_mill(find_value_tse_ed_t(doc, NET_SALES[accounting_base], context[:context_forecast].call(xbrl.quarter)))
        # 通期予想営業利益
        xbrl.forecast_operating_income = to_mill(find_value_tse_ed_t(doc, OPERATING_INCOME[accounting_base], context[:context_forecast].call(xbrl.quarter)))
        # 通期予想経常利益
        xbrl.forecast_ordinary_income = to_mill(find_value_tse_ed_t(doc, ORDINARY_INCOME[accounting_base], context[:context_forecast].call(xbrl.quarter)))
        # 通期予想純利益
        xbrl.forecast_net_income = to_mill(find_value_tse_ed_t(doc, NET_INCOME[accounting_base], context[:context_forecast].call(xbrl.quarter)))
        # 通期予想1株当たり純利益
        xbrl.forecast_net_income_per_share = to_f(find_value_tse_ed_t(doc, NET_INCOME_PER_SHARE[accounting_base], context[:context_forecast].call(xbrl.quarter)))

        xbrl
      end

=begin
      def self.find_accounting_base(doc, context, quarter)
        namespace = doc.namespaces.keys.find {|ns| ns.start_with? 'xmlns:tse-qced' }

        case namespace
        when /.+jpsm.+/
          :jp
        when /.+ussm.+/
          :us
        when /.+ifsm.+/
          :if
        else
          :jp
        end
      end
=end

      def attributes
        {
          code: code,
          year: year,
          month: month,
          quarter: quarter,
          net_sales: net_sales,
          operating_income: operating_income,
          ordinary_income: ordinary_income,
          net_income: net_income,
          net_income_per_share: net_income_per_share
        }
      end

      def attributes_results_forecast
        {
          code: code,
          year: quarter == 4 ? year + 1 : year,
          month: month,
          quarter: quarter,
          forecast_net_sales: forecast_net_sales,
          forecast_operating_income: forecast_operating_income,
          forecast_ordinary_income: forecast_ordinary_income,
          forecast_net_income: forecast_net_income,
          forecast_net_income_per_share: forecast_net_income_per_share
        }
      end

    end
  end
end