module LiteXBRL
  module TDnet
    module ResultsForecastAttribute

      attr_accessor :code, :year, :month, :quarter, :consolidation,
        :forecast_net_sales, :forecast_operating_income, :forecast_ordinary_income, :forecast_net_income, :forecast_net_income_per_share,
        :previous_forecast_net_sales, :previous_forecast_operating_income, :previous_forecast_ordinary_income, :previous_forecast_net_income, :previous_forecast_net_income_per_share,
        :change_forecast_net_sales, :change_forecast_operating_income, :change_forecast_ordinary_income, :change_forecast_net_income

      def attributes
        {
          code: code,
          year: year,
          month: month,
          quarter: quarter,
          consolidation: consolidation,
          forecast_net_sales: forecast_net_sales,
          forecast_operating_income: forecast_operating_income,
          forecast_ordinary_income: forecast_ordinary_income,
          forecast_net_income: forecast_net_income,
          forecast_net_income_per_share: forecast_net_income_per_share,
          previous_forecast_net_sales: previous_forecast_net_sales,
          previous_forecast_operating_income: previous_forecast_operating_income,
          previous_forecast_ordinary_income: previous_forecast_ordinary_income,
          previous_forecast_net_income: previous_forecast_net_income,
          previous_forecast_net_income_per_share: previous_forecast_net_income_per_share,
          change_forecast_net_sales: change_forecast_net_sales,
          change_forecast_operating_income: change_forecast_operating_income,
          change_forecast_ordinary_income: change_forecast_ordinary_income,
          change_forecast_net_income: change_forecast_net_income,
        }
      end

    end
  end
end