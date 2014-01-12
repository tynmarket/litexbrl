module LiteXBRL
  module TDnet
    module ResultsForecastAttribute

      attr_accessor :forecast_net_sales, :forecast_operating_income, :forecast_ordinary_income, :forecast_net_income, :forecast_net_income_per_share,
        :forecast_previous_net_sales, :forecast_previous_operating_income, :forecast_previous_ordinary_income, :forecast_previous_net_income, :forecast_previous_net_income_per_share,
        :change_forecast_net_sales, :change_forecast_operating_income, :change_forecast_ordinary_income, :change_forecast_net_income

      def attributes
        {
          code: code,
          year: year,
          month: month,
          quarter: quarter,
          forecast_net_sales: forecast_net_sales,
          forecast_operating_income: forecast_operating_income,
          forecast_ordinary_income: forecast_ordinary_income,
          forecast_net_income: forecast_net_income,
          forecast_net_income_per_share: forecast_net_income_per_share,
          forecast_previous_net_sales: forecast_previous_net_sales,
          forecast_previous_operating_income: forecast_previous_operating_income,
          forecast_previous_ordinary_income: forecast_previous_ordinary_income,
          forecast_previous_net_income: forecast_previous_net_income,
          forecast_previous_net_income_per_share: forecast_previous_net_income_per_share,
          change_forecast_net_sales: change_forecast_net_sales,
          change_forecast_operating_income: change_forecast_operating_income,
          change_forecast_ordinary_income: change_forecast_ordinary_income,
          change_forecast_net_income: change_forecast_net_income,
        }
      end

    end
  end
end