module LiteXBRL
  module TDnet
    class Summary
      include Utils

      attr_accessor :code, :year, :quarter,
        :net_sales, :operating_income, :ordinary_income, :net_income, :net_income_per_share,
        :forecast_net_sales, :forecast_operating_income, :forecast_ordinary_income, :forecast_net_income, :forecast_net_income_per_share

      # 名前空間
      NS = {
        'xbrli' => 'http://www.xbrl.org/2003/instance',
        'tse-t-ed' => 'http://www.xbrl.tdnet.info/jp/br/tdnet/t/ed/2007-06-30'
      }

      # 売上高
      NET_SALES = {
        jp: ['NetSales', 'OrdinaryRevenuesBK', 'OperatingRevenuesSE', 'OrdinaryRevenuesIN', 'OperatingRevenues',
          'OperatingRevenuesSpecific', 'GrossOperatingRevenues', 'NetSalesOfCompletedConstructionContracts'],
        us: ['NetSalesUS', 'OperatingRevenuesUS', 'NetSalesAndOperatingRevenuesUS', 'TotalRevenuesUS'],
        :if => ['NetSalesIFRS', 'OperatingRevenuesIFRS', 'SalesIFRS']
      }

      # 営業利益
      OPERATING_INCOME = {
        jp: [['OperatingIncome'], ['OrdinaryIncome']],
        us: [['OperatingIncomeUS', 'OperatingIncome'], ['IncomeBeforeIncomeTaxesUS']],
        :if => [['OperatingIncomeIFRS'], ['ProfitBeforeTaxIFRS']]
      }

      # 経常利益
      ORDINARY_INCOME = {
        jp: ['OrdinaryIncome'],
        us: ['IncomeBeforeIncomeTaxesUS', 'IncomeFromContinuingOperationsBeforeIncomeTaxesUS'],
        :if => ['ProfitBeforeTaxIFRS', 'ProfitBeforeIncomeTaxIFRS']
      }

      # 純利益
      NET_INCOME = {
        jp: ['NetIncome'],
        us: ['NetIncomeUS', 'IncomeBeforeMinorityInterestUS'],
        :if => ['ProfitAttributableToOwnersOfParentIFRS']
      }

      # 一株当たり純利益
      NET_INCOME_PER_SHARE = {
        jp: ['NetIncomePerShare'],
        us: ['NetIncomePerShareUS', 'BasicNetIncomePerShareUS'],
        :if => ['BasicEarningsPerShareIFRS', 'BasicEarningPerShareIFRS']
      }

      # 通期予想売上高
      FORECAST_NET_SALES = create_items(NET_SALES) {|item| "Forecast#{item}" }

      # 通期予想営業利益
      FORECAST_OPERATING_INCOME = OPERATING_INCOME.each_with_object({}) do |kv, hash|
        key, values = *kv
        hash[key] = values.map {|values2| values2.map {|item| "Forecast#{item}" } }
      end

      # 通期予想経常利益
      FORECAST_ORDINARY_INCOME = create_items(ORDINARY_INCOME) {|item| "Forecast#{item}" }

      # 通期予想純利益
      FORECAST_NET_INCOME = create_items(NET_INCOME) {|item| "Forecast#{item}" }

      # 通期予想一株当たり純利益
      FORECAST_NET_INCOME_PER_SHARE = create_items(NET_INCOME_PER_SHARE) {|item| "Forecast#{item}" }


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
          consolidation, season = find_consolidation_and_season(doc)
          context = context_hash(consolidation, season)

          xbrl = Summary.new

          # 証券コード
          xbrl.code = find_securities_code(doc, consolidation)
          # 会計年度
          xbrl.year = find_year(doc, consolidation)
          # 四半期
          xbrl.quarter = find_quarter(doc, consolidation, context)

          # 会計基準
          accounting_base = find_accounting_base(doc)

          # 売上高
          xbrl.net_sales = to_mill(find_value(doc, NET_SALES[accounting_base], context[:context_duration]))
          # 営業利益
          xbrl.operating_income = to_mill(find_value(doc, OPERATING_INCOME[accounting_base], context[:context_duration]))
          # 経常利益
          xbrl.ordinary_income = to_mill(find_value(doc, ORDINARY_INCOME[accounting_base], context[:context_duration]))
          # 純利益
          xbrl.net_income = to_mill(find_value(doc, NET_INCOME[accounting_base], context[:context_duration]))
          # 1株当たり純利益
          xbrl.net_income_per_share = to_f(find_value(doc, NET_INCOME_PER_SHARE[accounting_base], context[:context_duration]))

          # 通期予想売上高
          xbrl.forecast_net_sales = to_mill(find_value(doc, FORECAST_NET_SALES[accounting_base], context[:context_forecast].call(xbrl.quarter)))
          # 通期予想営業利益
          xbrl.forecast_operating_income = to_mill(find_value(doc, FORECAST_OPERATING_INCOME[accounting_base], context[:context_forecast].call(xbrl.quarter)))
          # 通期予想経常利益
          xbrl.forecast_ordinary_income = to_mill(find_value(doc, FORECAST_ORDINARY_INCOME[accounting_base], context[:context_forecast].call(xbrl.quarter)))
          # 通期予想純利益
          xbrl.forecast_net_income = to_mill(find_value(doc, FORECAST_NET_INCOME[accounting_base], context[:context_forecast].call(xbrl.quarter)))
          # 通期予想1株当たり純利益
          xbrl.forecast_net_income_per_share = to_f(find_value(doc, FORECAST_NET_INCOME_PER_SHARE[accounting_base], context[:context_forecast].call(xbrl.quarter)))

          xbrl
        end

        def find_consolidation_and_season(doc)
          consolidation = find_consolidation(doc)
          season = find_season(doc, consolidation)

          # 連結で取れない場合、非連結にする
          unless season
            consolidation = "NonConsolidated"
            season = find_season(doc, consolidation)
          end

          return consolidation, season
        end

        #
        # 連結・非連結を取得します
        #
        def find_consolidation(doc)
          cons = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentYearConsolidatedDuration']/xbrli:entity/xbrli:identifier", NS)
          non_cons = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentYearNonConsolidatedDuration']/xbrli:entity/xbrli:identifier", NS)

          if cons
            "Consolidated"
          elsif non_cons
            "NonConsolidated"
          else
            raise StandardError.new("連結・非連結ともに該当しません。")
          end
        end

        #
        # 通期・四半期を取得します
        #
        def find_season(doc, consolidation)
          year = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentYear#{consolidation}Instant']/xbrli:entity/xbrli:identifier", NS)
          quarter = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentQuarter#{consolidation}Instant']/xbrli:entity/xbrli:identifier", NS)
          q1 = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentAccumulatedQ1#{consolidation}Instant']/xbrli:entity/xbrli:identifier", NS)
          q2 = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentAccumulatedQ2#{consolidation}Instant']/xbrli:entity/xbrli:identifier", NS)
          q3 = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentAccumulatedQ3#{consolidation}Instant']/xbrli:entity/xbrli:identifier", NS)

          if year
            "Year"
          elsif quarter
            "Quarter"
          elsif q1
            "AccumulatedQ1"
          elsif q2
            "AccumulatedQ2"
          elsif q3
            "AccumulatedQ3"
          end
        end

        #
        # contextを設定します
        #
        def context_hash(consolidation, season)
          raise StandardError.new("通期・四半期が設定されていません。") unless season

          year_duration = "Year#{consolidation}Duration"

          {
            context_duration: "Current#{season}#{consolidation}Duration",
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
        # 会計年度を取得します
        #
        def find_year(doc, consolidation)
          elm_end = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentYear#{consolidation}Duration']/xbrli:period/xbrli:endDate", NS)
          to_year(elm_end)
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
        # 会計基準を取得します
        #
        def find_accounting_base(doc)
          namespace = doc.namespaces.keys.find {|ns| ns.start_with? 'xmlns:tdnet' }

          case namespace
          when /.+jpsm.+/
            :jp
          when /.+ussm.+/
            :us
          when /.+ifsm.+/
            :if
          end
        end

        #
        # 勘定科目の値を取得します
        #
        def find_value(doc, item, context)
          # 配列の場合、いずれかに該当するもの
          if item[0].is_a? String
            xpath = item.map {|item| "//xbrli:xbrl/tse-t-ed:#{item}[@contextRef='#{context}']" }.join('|')
            elm = doc.at_xpath xpath
            elm.content if elm
          # 2次元配列の場合、先頭の配列から優先に
          elsif item[0].is_a? Array
            item.each do |item|
              xpath = item.map {|item| "//xbrli:xbrl/tse-t-ed:#{item}[@contextRef='#{context}']" }.join('|')
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
          year: year,
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