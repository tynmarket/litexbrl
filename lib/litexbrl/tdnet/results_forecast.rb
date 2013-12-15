module LiteXBRL
  module TDnet
    class ResultsForecast < FinancialInfomration

      attr_accessor :forecast_net_sales, :forecast_operating_income, :forecast_ordinary_income, :forecast_net_income, :forecast_net_income_per_share

      def self.find_data(doc, xbrl, accounting_base, context)
        # 通期予想売上高
        xbrl.forecast_net_sales = to_mill(find_value(doc, FORECAST_NET_SALES[accounting_base], context[:context_forecast].call(1)))
        # 通期予想営業利益
        xbrl.forecast_operating_income = to_mill(find_value(doc, FORECAST_OPERATING_INCOME[accounting_base], context[:context_forecast].call(1)))
        # 通期予想経常利益
        xbrl.forecast_ordinary_income = to_mill(find_value(doc, FORECAST_ORDINARY_INCOME[accounting_base], context[:context_forecast].call(1)))
        # 通期予想純利益
        xbrl.forecast_net_income = to_mill(find_value(doc, FORECAST_NET_INCOME[accounting_base], context[:context_forecast].call(1)))
        # 通期予想1株当たり純利益
        xbrl.forecast_net_income_per_share = to_f(find_value(doc, FORECAST_NET_INCOME_PER_SHARE[accounting_base], context[:context_forecast].call(1)))

        xbrl
      end

      def self.find_accounting_base(doc, context, quarter)
        jp = find_value(doc, FORECAST_NET_INCOME[:jp], context[:context_forecast].call(1))
        us = find_value(doc, FORECAST_NET_INCOME[:us], context[:context_forecast].call(1))
        ifrs = find_value(doc, FORECAST_NET_INCOME[:if], context[:context_forecast].call(1))

        if jp
          :jp
        elsif us
          :us
        elsif ifrs
          :if
        else
          :jp
        end
      end

      def attributes
        super.merge(
          forecast_net_sales: forecast_net_sales,
          forecast_operating_income: forecast_operating_income,
          forecast_ordinary_income: forecast_ordinary_income,
          forecast_net_income: forecast_net_income,
          forecast_net_income_per_share: forecast_net_income_per_share
        )
      end

    end
  end
end