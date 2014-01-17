module LiteXBRL
  module TDnet
    class FinancialInformation2
      include Utils
      include AccountItem

      attr_accessor :code, :year, :month, :quarter

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
          accounting_base = find_accounting_base(doc, context)

          return xbrl, accounting_base, context
        end

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
          raise Exception.new "Override !"
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
            context_current_forecast: "CurrentYearDuration_#{consolidation}Member_CurrentMember_ForecastMember",
            context_prev_forecast: "CurrentYearDuration_#{consolidation}Member_PreviousMember_ForecastMember",
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
          raise Exception.new "Override !"
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
            add_sign(elm) if elm
          # 2次元配列の場合、先頭の配列から優先に
          elsif item[0].is_a? Array
            item.each do |item|
              xpath = item.map {|item| yield(item, context) }.join('|')
              elm = doc.at_xpath xpath
              return add_sign(elm) if elm
            end

            nil # 該当なし
          end
        end

        #
        # マイナスが設定されていれば付加します
        #
        def add_sign(elm)
          elm.attribute('sign') ? elm.attribute('sign').content + elm.content : elm.content
        end
      end

    end
  end
end