require 'nokogiri'

module LiteXBRL
  module TDnet
    class Summary
      extend Utils

      attr_accessor :code, :year, :quarter,
        :net_sales, :operating_income, :ordinary_income, :net_income, :net_income_per_share

      # 名前空間
      NS = {
        'xbrli' => 'http://www.xbrl.org/2003/instance',
        'tse-t-ed' => 'http://www.xbrl.tdnet.info/jp/br/tdnet/t/ed/2007-06-30'
      }

      # 売上高
      NET_SALES = {
        general: 'NetSales',
        bank: 'OrdinaryRevenuesBK',
        securities: 'OperatingRevenuesSE',
        insurance: 'OrdinaryRevenuesIN',
        operating_revenues: 'OperatingRevenues',
        operating_revenues_specific: 'OperatingRevenuesSpecific'
      }

      # 営業利益
      OPERATING_INCOME = {
        general: 'OperatingIncome',
        bank: 'OrdinaryIncome',
        securities: 'OperatingIncome',
        insurance: 'OrdinaryIncome',
        operating_revenues: 'OperatingIncome',
        operating_revenues_specific: 'OperatingIncome'
      }

      # 経常利益
      ORDINARY_INCOME = {
        general: 'OrdinaryIncome',
        bank: 'OrdinaryIncome',
        securities: 'OrdinaryIncome',
        insurance: 'OrdinaryIncome',
        operating_revenues: 'OrdinaryIncome',
        operating_revenues_specific: 'OrdinaryIncome'
      }

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

          # 業種
          sector = find_sector(doc, context[:context_duration])

          # 売上高
          xbrl.net_sales = to_mill(find_value(doc, NET_SALES[sector], context[:context_duration]))
          # 営業利益
          xbrl.operating_income = to_mill(find_value(doc, OPERATING_INCOME[sector], context[:context_duration]))
          # 経常利益
          xbrl.ordinary_income = to_mill(find_value(doc, ORDINARY_INCOME[sector], context[:context_duration]))
          # 純利益
          xbrl.net_income = to_mill(find_value(doc, "NetIncome", context[:context_duration]))
          # 1株当たり純利益
          xbrl.net_income_per_share = to_f(find_value(doc, "NetIncomePerShare", context[:context_duration]))

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

          {
            context_duration: "Current#{season}#{consolidation}Duration",
            context_instant: "Current#{season}#{consolidation}Instant"
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
        # 業種を取得します
        #
        def find_sector(doc, context)
          # 一般商工業
          net_sales = doc.at_xpath("//xbrli:xbrl/tse-t-ed:NetSales[@contextRef='#{context}']", NS)
          return :general if net_sales

          # 銀行
          ordinary_revenues_bk = doc.at_xpath("//xbrli:xbrl/tse-t-ed:OrdinaryRevenuesBK[@contextRef='#{context}']", NS)
          return :bank if ordinary_revenues_bk

          # 証券
          operating_revenues_in = doc.at_xpath("//xbrli:xbrl/tse-t-ed:OperatingRevenuesSE[@contextRef='#{context}']", NS)
          return :securities if operating_revenues_in

          # 保険
          ordinary_revenues_in = doc.at_xpath("//xbrli:xbrl/tse-t-ed:OrdinaryRevenuesIN[@contextRef='#{context}']", NS)
          return :insurance if ordinary_revenues_in

          # 営業収益（Olympic、いちよし証券など）
          operating_revenues = doc.at_xpath("//xbrli:xbrl/tse-t-ed:OperatingRevenues[@contextRef='#{context}']", NS)
          return :operating_revenues if operating_revenues

          # 営業収入（ミニストップ、メッセージなど）
          operating_revenues_specific = doc.at_xpath("//xbrli:xbrl/tse-t-ed:OperatingRevenuesSpecific[@contextRef='#{context}']", NS)
          return :operating_revenues_specific if operating_revenues_specific

          # 不明
          return :general
        end

        #
        # 勘定科目の値を取得します
        #
        def find_value(doc, item, context)
          elm = doc.at_xpath("//xbrli:xbrl/tse-t-ed:#{item}[@contextRef='#{context}']", NS)
          elm.content if elm
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

    end
  end
end