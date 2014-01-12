module LiteXBRL
  module TDnet
    class ResultsForecast < FinancialInformation
      include ResultsForecastAttribute

      def self.find_data(doc, xbrl, accounting_base, context)
        # 通期予想売上高
        xbrl.forecast_net_sales = to_mill(find_value_tse_t_ed(doc, FORECAST_NET_SALES[accounting_base], context[:context_duration]))
        # 通期予想営業利益
        xbrl.forecast_operating_income = to_mill(find_value_tse_t_ed(doc, FORECAST_OPERATING_INCOME[accounting_base], context[:context_duration]))
        # 通期予想経常利益
        xbrl.forecast_ordinary_income = to_mill(find_value_tse_t_ed(doc, FORECAST_ORDINARY_INCOME[accounting_base], context[:context_duration]))
        # 通期予想純利益
        xbrl.forecast_net_income = to_mill(find_value_tse_t_ed(doc, FORECAST_NET_INCOME[accounting_base], context[:context_duration]))
        # 通期予想1株当たり純利益
        xbrl.forecast_net_income_per_share = to_f(find_value_tse_t_ed(doc, FORECAST_NET_INCOME_PER_SHARE[accounting_base], context[:context_duration]))

        # 修正前通期予想売上高
        xbrl.forecast_previous_net_sales = to_mill(find_value_tse_t_rv(doc, FORECAST_PREVIOUS_NET_SALES[accounting_base], context[:context_duration]))
        # 修正前通期予想営業利益
        xbrl.forecast_previous_operating_income = to_mill(find_value_tse_t_rv(doc, FORECAST_PREVIOUS_OPERATING_INCOME[accounting_base], context[:context_duration]))
        # 修正前通期予想経常利益
        xbrl.forecast_previous_ordinary_income = to_mill(find_value_tse_t_rv(doc, FORECAST_PREVIOUS_ORDINARY_INCOME[accounting_base], context[:context_duration]))
        # 修正前通期予想純利益
        xbrl.forecast_previous_net_income = to_mill(find_value_tse_t_rv(doc, FORECAST_PREVIOUS_NET_INCOME[accounting_base], context[:context_duration]))
        # 修正前通期予想1株当たり純利益
        xbrl.forecast_previous_net_income_per_share = to_f(find_value_tse_t_rv(doc, FORECAST_PREVIOUS_NET_INCOME_PER_SHARE[accounting_base], context[:context_duration]))

        # 通期予想売上高増減率
        xbrl.change_forecast_net_sales = to_f(find_value_tse_t_rv(doc, CHANGE_NET_SALES[accounting_base], context[:context_duration]))
        # 通期予想営業利益増減率
        xbrl.change_forecast_operating_income = to_f(find_value_tse_t_rv(doc, CHANGE_OPERATING_INCOME[accounting_base], context[:context_duration]))
        # 通期予想経常利益増減率
        xbrl.change_forecast_ordinary_income = to_f(find_value_tse_t_rv(doc, CHANGE_ORDINARY_INCOME[accounting_base], context[:context_duration]))
        # 通期予想純利益増減率
        xbrl.change_forecast_net_income = to_f(find_value_tse_t_rv(doc, CHANGE_NET_INCOME[accounting_base], context[:context_duration]))

        xbrl
      end

      def self.find_accounting_base(doc, context, quarter)
        if find_value_tse_t_ed(doc, FORECAST_NET_INCOME[:jp], context[:context_duration])
          :jp
        elsif find_value_tse_t_ed(doc, FORECAST_NET_INCOME[:us], context[:context_duration])
          :us
        elsif find_value_tse_t_ed(doc, FORECAST_NET_INCOME[:if], context[:context_duration])
          :if
        elsif find_value_tse_t_rv(doc, FORECAST_PREVIOUS_NET_INCOME[:jp], context[:context_duration])
          :jp
        elsif find_value_tse_t_rv(doc, FORECAST_PREVIOUS_NET_INCOME[:us], context[:context_duration])
          :us
        elsif find_value_tse_t_rv(doc, FORECAST_PREVIOUS_NET_INCOME[:if], context[:context_duration])
          :if
        else
          :jp
        end
      end

      #
      # 修正報告の勘定科目の値を取得します
      #
      def self.find_value_tse_t_rv(doc, item, context)
        find_value(doc, item, context) do |item, context|
          "//xbrli:xbrl/tse-t-rv:#{item}[@contextRef='#{context}']"
        end
      end

    end
  end
end