module LiteXBRL
  module TDnet
    class ResultsForecast2 < FinancialInformation2
      include ResultsForecastAttribute

      def self.find_data(doc, xbrl, accounting_base, context)
        # 通期予想売上高
        xbrl.forecast_net_sales = to_i(find_value_tse_ed_t(doc, NET_SALES[accounting_base], context[:context_current_forecast]))
        # 通期予想営業利益
        xbrl.forecast_operating_income = to_i(find_value_tse_ed_t(doc, OPERATING_INCOME[accounting_base], context[:context_current_forecast]))
        # 通期予想経常利益
        xbrl.forecast_ordinary_income = to_i(find_value_tse_ed_t(doc, ORDINARY_INCOME[accounting_base], context[:context_current_forecast]))
        # 通期予想純利益
        xbrl.forecast_net_income = to_i(find_value_tse_ed_t(doc, NET_INCOME[accounting_base], context[:context_current_forecast]))
        # 通期予想1株当たり純利益
        xbrl.forecast_net_income_per_share = to_f(find_value_tse_ed_t(doc, NET_INCOME_PER_SHARE[accounting_base], context[:context_current_forecast]))

        # 修正前通期予想売上高
        xbrl.forecast_previous_net_sales = to_i(find_value_tse_ed_t(doc, NET_SALES[accounting_base], context[:context_prev_forecast]))
        # 修正前通期予想営業利益
        xbrl.forecast_previous_operating_income = to_i(find_value_tse_ed_t(doc, OPERATING_INCOME[accounting_base], context[:context_prev_forecast]))
        # 修正前通期予想経常利益
        xbrl.forecast_previous_ordinary_income = to_i(find_value_tse_ed_t(doc, ORDINARY_INCOME[accounting_base], context[:context_prev_forecast]))
        # 修正前通期予想純利益
        xbrl.forecast_previous_net_income = to_i(find_value_tse_ed_t(doc, NET_INCOME[accounting_base], context[:context_prev_forecast]))
        # 修正前通期予想1株当たり純利益
        xbrl.forecast_previous_net_income_per_share = to_f(find_value_tse_ed_t(doc, NET_INCOME_PER_SHARE[accounting_base], context[:context_prev_forecast]))

        # 通期予想売上高増減率
        xbrl.change_forecast_net_sales = percent_to_f(find_value_tse_ed_t(doc, CHANGE_IN_NET_SALES[accounting_base], context[:context_current_forecast]))
        # 通期予想営業利益増減率
        xbrl.change_forecast_operating_income = percent_to_f(find_value_tse_ed_t(doc, CHANGE_IN_OPERATING_INCOME[accounting_base], context[:context_current_forecast]))
        # 通期予想経常利益増減率
        xbrl.change_forecast_ordinary_income = percent_to_f(find_value_tse_ed_t(doc, CHANGE_IN_ORDINARY_INCOME[accounting_base], context[:context_current_forecast]))
        # 通期予想純利益増減率
        xbrl.change_forecast_net_income = percent_to_f(find_value_tse_ed_t(doc, CHANGE_IN_NET_INCOME[accounting_base], context[:context_current_forecast]))

        xbrl
      end

      def self.find_consolidation(doc, season)
        cons = find_value_tse_ed_t(doc, NET_SALES.values.flatten, "CurrentYearDuration_ConsolidatedMember_CurrentMember_ForecastMember")
        non_cons = find_value_tse_ed_t(doc, NET_SALES.values.flatten, "CurrentYearDuration_NonConsolidatedMember_CurrentMember_ForecastMember")

        if cons
          "Consolidated"
        elsif non_cons
          "NonConsolidated"
        else
          raise Exception.new("連結・非連結ともに該当しません。")
        end
      end

      def self.find_accounting_base(doc, context)
        if find_value_tse_ed_t(doc, NET_INCOME[:jp], context[:context_current_forecast])
          :jp
        elsif find_value_tse_ed_t(doc, NET_INCOME[:us], context[:context_current_forecast])
          :us
        elsif find_value_tse_ed_t(doc, NET_INCOME[:if], context[:context_current_forecast])
          :if
        elsif find_value_tse_ed_t(doc, NET_INCOME[:jp], context[:context_prev_forecast])
          :jp
        elsif find_value_tse_ed_t(doc, NET_INCOME[:us], context[:context_prev_forecast])
          :us
        elsif find_value_tse_ed_t(doc, NET_INCOME[:if], context[:context_prev_forecast])
          :if
        else
          raise Exception.new("会計基準を取得出来ません。")
        end
      end

    end
  end
end