module LiteXBRL
  module TDnet
    module AccountItem

      def self.define_item(items, &block)
        items.map do |item|
          block.call item
        end.flatten
      end

      def self.define_nested_item(nested_items, &block)
        nested_items.map do |items|
          define_item(items, &block)
        end
      end

      # 売上高
      NET_SALES = ['NetSales', 'OrdinaryRevenuesBK', 'OperatingRevenuesSE', 'OrdinaryRevenuesIN', 'OperatingRevenues',
        'OperatingRevenuesSpecific', 'GrossOperatingRevenues', 'NetSalesOfCompletedConstructionContracts',
        'NetSalesUS', 'OperatingRevenuesUS', 'NetSalesAndOperatingRevenuesUS', 'TotalRevenuesUS',
        'NetSalesIFRS', 'OperatingRevenuesIFRS', 'SalesIFRS', 'RevenueIFRS']

      # 営業利益
      OPERATING_INCOME = [['OperatingIncome', 'OperatingIncomeUS', 'OperatingIncomeIFRS'],
        ['OrdinaryIncome', 'IncomeBeforeIncomeTaxesUS', 'ProfitBeforeTaxIFRS']]

      # 経常利益
      ORDINARY_INCOME = ['OrdinaryIncome', 'IncomeBeforeIncomeTaxesUS', 'IncomeFromContinuingOperationsBeforeIncomeTaxesUS',
          'ProfitBeforeTaxIFRS', 'ProfitBeforeIncomeTaxIFRS']

      # 純利益
      NET_INCOME = ['NetIncome', 'ProfitAttributableToOwnersOfParent', 'NetIncomeUS',
        'IncomeBeforeMinorityInterestUS', 'ProfitAttributableToOwnersOfParentIFRS']

      # 一株当たり純利益
      NET_INCOME_PER_SHARE = ['NetIncomePerShare', 'NetIncomePerShareUS', 'BasicNetIncomePerShareUS',
        'BasicEarningsPerShareIFRS', 'BasicEarningPerShareIFRS']

      # 売上高前年比/通期予想売上高前年比
      CHANGE_IN_NET_SALES = define_item(NET_SALES) {|item| ["ChangeIn#{item}", "ChangesIn#{item}"] }

      # 営業利益前年比/通期予想営業利益前年比
      CHANGE_IN_OPERATING_INCOME = define_nested_item(OPERATING_INCOME) {|item| ["ChangeIn#{item}", "ChangesIn#{item}"] }

      # 経常利益前年比/通期予想経常利益前年比
      CHANGE_IN_ORDINARY_INCOME = define_item(ORDINARY_INCOME) {|item| ["ChangeIn#{item}", "ChangesIn#{item}"] }

      # 純利益前年比/通期予想純利益前年比
      CHANGE_IN_NET_INCOME = define_item(NET_INCOME) {|item| ["ChangeIn#{item}", "ChangesIn#{item}"] }


      # 通期/第2四半期予想売上高
      FORECAST_NET_SALES = define_item(NET_SALES) {|item| "Forecast#{item}" }

      # 通期/第2四半期予想営業利益
      FORECAST_OPERATING_INCOME = define_nested_item(OPERATING_INCOME) {|item| "Forecast#{item}" }

      # 通期/第2四半期予想経常利益
      FORECAST_ORDINARY_INCOME = define_item(ORDINARY_INCOME) {|item| "Forecast#{item}" }

      # 通期/第2四半期予想純利益
      FORECAST_NET_INCOME = define_item(NET_INCOME) {|item| "Forecast#{item}" }

      # 通期/第2四半期予想一株当たり純利益
      FORECAST_NET_INCOME_PER_SHARE = define_item(NET_INCOME_PER_SHARE) {|item| "Forecast#{item}" }

      # 通期予想売上高前年比
      CHANGE_FORECAST_NET_SALES = define_item(NET_SALES) {|item| "ChangeForecast#{item}" }

      # 通期予想営業利益前年比
      CHANGE_FORECAST_OPERATING_INCOME = define_nested_item(OPERATING_INCOME) {|item| "ChangeForecast#{item}" }

      # 通期予想経常利益前年比
      CHANGE_FORECAST_ORDINARY_INCOME = define_item(ORDINARY_INCOME) {|item| "ChangeForecast#{item}" }

      # 通期予想純利益前年比
      CHANGE_FORECAST_NET_INCOME = define_item(NET_INCOME) {|item| "ChangeForecast#{item}" }


      # 修正前通期/第2四半期予想売上高
      PREVIOUS_FORECAST_NET_SALES = define_item(NET_SALES) {|item| "ForecastPrevious#{item}" }

      # 修正前通期/第2四半期予想営業利益
      PREVIOUS_FORECAST_OPERATING_INCOME = define_nested_item(OPERATING_INCOME) {|item| "ForecastPrevious#{item}" }

      # 修正前通期/第2四半期予想経常利益
      PREVIOUS_FORECAST_ORDINARY_INCOME = define_item(ORDINARY_INCOME) {|item| "ForecastPrevious#{item}" }

      # 修正前通期/第2四半期予想純利益
      PREVIOUS_FORECAST_NET_INCOME = define_item(NET_INCOME) {|item| "ForecastPrevious#{item}" }

      # 修正前通期/第2四半期予想一株当たり純利益
      PREVIOUS_FORECAST_NET_INCOME_PER_SHARE = define_item(NET_INCOME_PER_SHARE) {|item| "ForecastPrevious#{item}" }

      # 通期/第2四半期予想売上高増減率
      CHANGE_NET_SALES = define_item(NET_SALES) {|item| "Change#{item}" }

      # 通期/第2四半期予想営業利益増減率
      CHANGE_OPERATING_INCOME = define_nested_item(OPERATING_INCOME) {|item| "Change#{item}" }

      # 通期/第2四半期予想経常利益増減率
      CHANGE_ORDINARY_INCOME = define_item(ORDINARY_INCOME) {|item| "Change#{item}" }

      # 通期/第2四半期予想純利益増減率
      CHANGE_NET_INCOME = define_item(NET_INCOME) {|item| "Change#{item}" }


      # 1株当たり純資産
      NET_ASSETS_PER_SHARE = ["NetAssetsPerShare", "EquityAttributableToOwnersOfParentPerShareIFRS", "ShareholdersEquityPerShareUS"]


      # 企業名
      COMPANY_NAME = ['CompanyName']

    end
  end
end