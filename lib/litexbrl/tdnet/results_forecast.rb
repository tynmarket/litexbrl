module LiteXBRL
  module TDnet
    class ResultsForecast < FinancialInformation

      attr_accessor :forecast_net_sales, :forecast_operating_income, :forecast_ordinary_income, :forecast_net_income, :forecast_net_income_per_share,
        :forecast_previous_net_sales, :forecast_previous_operating_income, :forecast_previous_ordinary_income, :forecast_previous_net_income, :forecast_previous_net_income_per_share

      # 修正前通期予想売上高
      FORECAST_PREVIOUS_NET_SALES = create_items(NET_SALES) {|item| "ForecastPrevious#{item}" }

      # 修正前通期予想営業利益
      FORECAST_PREVIOUS_OPERATING_INCOME = OPERATING_INCOME.each_with_object({}) do |kv, hash|
        key, values = *kv
        hash[key] = values.map {|values2| values2.map {|item| "ForecastPrevious#{item}" } }
      end

      # 修正前通期予想経常利益
      FORECAST_PREVIOUS_ORDINARY_INCOME = create_items(ORDINARY_INCOME) {|item| "ForecastPrevious#{item}" }

      # 修正前通期予想純利益
      FORECAST_PREVIOUS_NET_INCOME = create_items(NET_INCOME) {|item| "ForecastPrevious#{item}" }

      # 修正前通期予想一株当たり純利益
      FORECAST_PREVIOUS_NET_INCOME_PER_SHARE = create_items(NET_INCOME_PER_SHARE) {|item| "ForecastPrevious#{item}" }


      def self.find_data(doc, xbrl, accounting_base, context)
        # 通期予想売上高
        xbrl.forecast_net_sales = to_mill(find_value_tse_t_ed(doc, FORECAST_NET_SALES[accounting_base], context[:context_forecast].call(1)))
        # 通期予想営業利益
        xbrl.forecast_operating_income = to_mill(find_value_tse_t_ed(doc, FORECAST_OPERATING_INCOME[accounting_base], context[:context_forecast].call(1)))
        # 通期予想経常利益
        xbrl.forecast_ordinary_income = to_mill(find_value_tse_t_ed(doc, FORECAST_ORDINARY_INCOME[accounting_base], context[:context_forecast].call(1)))
        # 通期予想純利益
        xbrl.forecast_net_income = to_mill(find_value_tse_t_ed(doc, FORECAST_NET_INCOME[accounting_base], context[:context_forecast].call(1)))
        # 通期予想1株当たり純利益
        xbrl.forecast_net_income_per_share = to_f(find_value_tse_t_ed(doc, FORECAST_NET_INCOME_PER_SHARE[accounting_base], context[:context_forecast].call(1)))
        # 修正前通期予想売上高
        xbrl.forecast_previous_net_sales = to_mill(find_value_tse_t_rv(doc, FORECAST_PREVIOUS_NET_SALES[accounting_base], context[:context_forecast].call(1)))
        # 修正前通期予想営業利益
        xbrl.forecast_previous_operating_income = to_mill(find_value_tse_t_rv(doc, FORECAST_PREVIOUS_OPERATING_INCOME[accounting_base], context[:context_forecast].call(1)))
        # 修正前通期予想経常利益
        xbrl.forecast_previous_ordinary_income = to_mill(find_value_tse_t_rv(doc, FORECAST_PREVIOUS_ORDINARY_INCOME[accounting_base], context[:context_forecast].call(1)))
        # 修正前通期予想純利益
        xbrl.forecast_previous_net_income = to_mill(find_value_tse_t_rv(doc, FORECAST_PREVIOUS_NET_INCOME[accounting_base], context[:context_forecast].call(1)))
        # 修正前通期予想1株当たり純利益
        xbrl.forecast_previous_net_income_per_share = to_f(find_value_tse_t_rv(doc, FORECAST_PREVIOUS_NET_INCOME_PER_SHARE[accounting_base], context[:context_forecast].call(1)))

        xbrl
      end

      def self.find_accounting_base(doc, context, quarter)
        if find_value_tse_t_ed(doc, FORECAST_NET_INCOME[:jp], context[:context_forecast].call(1))
          :jp
        elsif find_value_tse_t_ed(doc, FORECAST_NET_INCOME[:us], context[:context_forecast].call(1))
          :us
        elsif find_value_tse_t_ed(doc, FORECAST_NET_INCOME[:if], context[:context_forecast].call(1))
          :if
        elsif find_value_tse_t_rv(doc, FORECAST_PREVIOUS_NET_INCOME[:jp], context[:context_forecast].call(1))
          :jp
        elsif find_value_tse_t_rv(doc, FORECAST_PREVIOUS_NET_INCOME[:us], context[:context_forecast].call(1))
          :us
        elsif find_value_tse_t_rv(doc, FORECAST_PREVIOUS_NET_INCOME[:if], context[:context_forecast].call(1))
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

      def attributes
        super.merge(
          forecast_net_sales: forecast_net_sales,
          forecast_operating_income: forecast_operating_income,
          forecast_ordinary_income: forecast_ordinary_income,
          forecast_net_income: forecast_net_income,
          forecast_net_income_per_share: forecast_net_income_per_share,
          forecast_previous_net_sales: forecast_previous_net_sales,
          forecast_previous_operating_income: forecast_previous_operating_income,
          forecast_previous_ordinary_income: forecast_previous_ordinary_income,
          forecast_previous_net_income: forecast_previous_net_income,
          forecast_previous_net_income_per_share: forecast_previous_net_income_per_share
        )
      end

    end
  end
end