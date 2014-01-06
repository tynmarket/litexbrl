module LiteXBRL
  module TDnet
    module AccountItem

      def self.create_items(items)
        items.each_with_object({}) do |kv, hash|
          key, values = *kv
          hash[key] = values.map {|item| yield item }
        end
      end

      # 売上高
      NET_SALES = {
        jp: ['NetSales', 'OrdinaryRevenuesBK', 'OperatingRevenuesSE', 'OrdinaryRevenuesIN', 'OperatingRevenues',
          'OperatingRevenuesSpecific', 'GrossOperatingRevenues', 'NetSalesOfCompletedConstructionContracts'],
        us: ['NetSalesUS', 'OperatingRevenuesUS', 'NetSalesAndOperatingRevenuesUS', 'TotalRevenuesUS'],
        :if => ['NetSalesIFRS', 'OperatingRevenuesIFRS', 'SalesIFRS']
      }

      # 営業利益
      OPERATING_INCOME = {
        jp: [['OperatingIncome'], ['OrdinaryIncome']],
        us: [['OperatingIncomeUS', 'OperatingIncome'], ['IncomeBeforeIncomeTaxesUS']],
        :if => [['OperatingIncomeIFRS'], ['ProfitBeforeTaxIFRS']]
      }

      # 経常利益
      ORDINARY_INCOME = {
        jp: ['OrdinaryIncome'],
        us: ['IncomeBeforeIncomeTaxesUS', 'IncomeFromContinuingOperationsBeforeIncomeTaxesUS'],
        :if => ['ProfitBeforeTaxIFRS', 'ProfitBeforeIncomeTaxIFRS']
      }

      # 純利益
      NET_INCOME = {
        jp: ['NetIncome'],
        us: ['NetIncomeUS', 'IncomeBeforeMinorityInterestUS'],
        :if => ['ProfitAttributableToOwnersOfParentIFRS']
      }

      # 一株当たり純利益
      NET_INCOME_PER_SHARE = {
        jp: ['NetIncomePerShare'],
        us: ['NetIncomePerShareUS', 'BasicNetIncomePerShareUS'],
        :if => ['BasicEarningsPerShareIFRS', 'BasicEarningPerShareIFRS']
      }

      # 通期予想売上高
      FORECAST_NET_SALES = create_items(NET_SALES) {|item| "Forecast#{item}" }

      # 通期予想営業利益
      FORECAST_OPERATING_INCOME = OPERATING_INCOME.each_with_object({}) do |kv, hash|
        key, values = *kv
        hash[key] = values.map {|values2| values2.map {|item| "Forecast#{item}" } }
      end

      # 通期予想経常利益
      FORECAST_ORDINARY_INCOME = create_items(ORDINARY_INCOME) {|item| "Forecast#{item}" }

      # 通期予想純利益
      FORECAST_NET_INCOME = create_items(NET_INCOME) {|item| "Forecast#{item}" }

      # 通期予想一株当たり純利益
      FORECAST_NET_INCOME_PER_SHARE = create_items(NET_INCOME_PER_SHARE) {|item| "Forecast#{item}" }

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

    end
  end
end