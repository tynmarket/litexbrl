module LiteXBRL
  module TDnet
    class FinancialInformation2
      include Utils
      include AccountItem

      attr_accessor :code, :year, :month, :quarter

      class << self

        private

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
        # 決算短信サマリの勘定科目の値を取得します
        #
        def find_value_tse_ed_t(doc, item, context)
          find_value(doc, item, context) do |item, context|
            "//ix:nonFraction[@contextRef='#{context}' and @name='tse-ed-t:#{item}']"
          end
        end

        #
        # 決算短信サマリの非数値の値を取得します
        #
        def find_value_non_numeric(doc, item, context)
          find_value(doc, item, context) do |item, context|
            "//ix:nonNumeric[@contextRef='#{context}' and @name='tse-ed-t:#{item}']"
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