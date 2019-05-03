module LiteXBRL
  module TDnet
    class CashFlow2 < FinancialInformation2
      # 日本会計基準, IFRS（通期のみ）, 米国会計基準はSummaryのみ
      ACCOUNTING_STANDARDS = [
        ["jppfs_cor", ""],
        ["jpigp_cor", "IFRS"]
      ]

      CONTEXT_FINAL = "CurrentYearDuration"
      CONTEXTS = [CONTEXT_FINAL, "CurrentYTDDuration"]

      class << self
        def read(doc)
          accountings, context = find_base_data(doc)
          context_instant = find_context_instant(context)
          xbrl = {}

          # 営業キャッシュフロー
          xbrl[:net_cash_provided_by_used_in_operating_activities] =
            find_value(doc, accountings, context, "NetCashProvidedByUsedInOperatingActivities")

          items_investment = ["NetCashProvidedByUsedInInvestmentActivities", "NetCashProvidedByUsedInInvestingActivities"]

          # 投資キャッシュフロー
          xbrl[:net_cash_provided_by_used_in_investment_activities] =
            find_value(doc, accountings, context, items_investment)

          # 財務キャッシュフロー
          xbrl[:net_cash_provided_by_used_in_financing_activities] =
            find_value(doc, accountings, context, "NetCashProvidedByUsedInFinancingActivities")

          # 現金及び現金同等物の増減額
          xbrl[:net_increase_decrease_in_cash_and_cash_equivalents] =
            find_value(doc, accountings, context, "NetIncreaseDecreaseInCashAndCashEquivalents")

          # 現金及び現金同等物の期首残高
          xbrl[:prior_cash_and_cash_equivalents] =
            find_value(doc, accountings, "Prior1YearInstant", "CashAndCashEquivalents")


          # 現金及び現金同等物の期末残高
          xbrl[:cash_and_cash_equivalents] =
            find_value(doc, accountings, context_instant, "CashAndCashEquivalents")

          return xbrl
        end

        private

        def find_base_data(doc)
          ACCOUNTING_STANDARDS.product(CONTEXTS).each do |accountings_and_context|
            accountings, context = *accountings_and_context
            item = "NetCashProvidedByUsedInOperatingActivities"

            value = find_value(doc, accountings, context, item)

            return [accountings, context] if value
          end

          raise StandardError.new("会計基準・Contextが見つかりません。")
        end

        def find_context_instant(context)
          context == CONTEXT_FINAL ? "CurrentYearInstant" : "CurrentQuarterInstant"
        end

        def find_value(doc, accountings, context, item)
          xpath = item_to_xpath(accountings, context, item)
          elm = doc.at_xpath xpath

          return unless elm

          value = to_i elm.content
          scale = elm.attribute("scale")&.content # 取得できない場合は百万円と仮定
          sign = elm.attribute('sign')&.content

          value /= 1000 if scale == "3"

          sign ? -value : value
        end

        def item_to_xpath(accountings, context, items)
          if items.is_a? Array
            xpaths = items.map do |item|
              item = item_name(accountings, item)
              to_xpath(context, item)
            end
            xpaths.join('|')
          else
            item = item_name(accountings, items)
            to_xpath(context, item)
          end
        end

        def item_name(accountings, item)
          "#{accountings[0]}:#{item}#{accountings[1]}"
        end

        def to_xpath(context, item)
          "//ix:nonFraction[@contextRef='#{context}' and @name='#{item}']"
        end
      end

    end
  end
end