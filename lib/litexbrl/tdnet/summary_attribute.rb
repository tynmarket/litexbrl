module LiteXBRL
  module TDnet
    module SummaryAttribute

      attr_accessor :net_sales, :operating_income, :ordinary_income, :net_income, :net_income_per_share,
        :change_in_net_sales, :change_in_operating_income, :change_in_ordinary_income, :change_in_net_income,
        :forecast_net_sales, :forecast_operating_income, :forecast_ordinary_income, :forecast_net_income, :forecast_net_income_per_share,
        :change_in_forecast_net_sales, :change_in_forecast_operating_income, :change_in_forecast_ordinary_income, :change_in_forecast_net_income

      def attributes
        {
          code: code,
          year: year,
          month: month,
          quarter: quarter,
          net_sales: net_sales,
          operating_income: operating_income,
          ordinary_income: ordinary_income,
          net_income: net_income,
          net_income_per_share: net_income_per_share,
          change_in_net_sales: change_in_net_sales,
          change_in_operating_income: change_in_operating_income,
          change_in_ordinary_income: change_in_ordinary_income,
          change_in_net_income: change_in_net_income,
        }
      end

      def attributes_results_forecast
        {
          code: code,
          year: quarter == 4 ? year + 1 : year,
          month: month,
          quarter: quarter,
          forecast_net_sales: forecast_net_sales,
          forecast_operating_income: forecast_operating_income,
          forecast_ordinary_income: forecast_ordinary_income,
          forecast_net_income: forecast_net_income,
          forecast_net_income_per_share: forecast_net_income_per_share,
          change_in_forecast_net_sales: change_in_forecast_net_sales,
          change_in_forecast_operating_income: change_in_forecast_operating_income,
          change_in_forecast_ordinary_income: change_in_forecast_ordinary_income,
          change_in_forecast_net_income: change_in_forecast_net_income,
        }
      end

    end
  end
end