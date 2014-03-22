module LiteXBRL
  module TDnet
    module AccountItem

      def self.define_item(items)
        items.each_with_object({}) do |kv, hash|
          key, values = *kv
          hash[key] = values.map do |item|
            decorated = yield item
            decorated.is_a?(Hash) ? decorated[key] : decorated
          end.flatten
        end
      end

      def self.define_nested_item(items)
        items.each_with_object({}) do |kv, hash|
          key, values = *kv
          hash[key] = values.map do |values2|
            values2.map do |item|
              decorated = yield item
              decorated.is_a?(Hash) ? decorated[key] : decorated
            end.flatten
          end
        end
      end

      # 売上高
      NET_SALES = {
        jp: ['NetSales', 'OrdinaryRevenuesBK', 'OperatingRevenuesSE', 'OrdinaryRevenuesIN', 'OperatingRevenues',
          'OperatingRevenuesSpecific', 'GrossOperatingRevenues', 'NetSalesOfCompletedConstructionContracts'],
        us: ['NetSalesUS', 'OperatingRevenuesUS', 'NetSalesAndOperatingRevenuesUS', 'TotalRevenuesUS', 'NetSales'],
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

      # 売上高前年比/通期予想売上高前年比
      CHANGE_IN_NET_SALES = define_item(NET_SALES) {|item| {jp: "ChangeIn#{item}", us: "ChangeIn#{item}", :if => ["ChangeIn#{item}", "ChangesIn#{item}"]} }

      # 営業利益前年比/通期予想営業利益前年比
      CHANGE_IN_OPERATING_INCOME = define_nested_item(OPERATING_INCOME) {|item| {jp: "ChangeIn#{item}", us: "ChangeIn#{item}", :if => ["ChangeIn#{item}", "ChangesIn#{item}"]} }

      # 経常利益前年比/通期予想経常利益前年比
      CHANGE_IN_ORDINARY_INCOME = define_item(ORDINARY_INCOME) {|item| {jp: "ChangeIn#{item}", us: "ChangeIn#{item}", :if => ["ChangeIn#{item}", "ChangesIn#{item}"]} }

      # 純利益前年比/通期予想純利益前年比
      CHANGE_IN_NET_INCOME = define_item(NET_INCOME) {|item| {jp: "ChangeIn#{item}", us: "ChangeIn#{item}", :if => ["ChangeIn#{item}", "ChangesIn#{item}"]} }


      # 通期予想売上高
      FORECAST_NET_SALES = define_item(NET_SALES) {|item| "Forecast#{item}" }

      # 通期予想営業利益
      FORECAST_OPERATING_INCOME = define_nested_item(OPERATING_INCOME) {|item| "Forecast#{item}" }

      # 通期予想経常利益
      FORECAST_ORDINARY_INCOME = define_item(ORDINARY_INCOME) {|item| "Forecast#{item}" }

      # 通期予想純利益
      FORECAST_NET_INCOME = define_item(NET_INCOME) {|item| "Forecast#{item}" }

      # 通期予想一株当たり純利益
      FORECAST_NET_INCOME_PER_SHARE = define_item(NET_INCOME_PER_SHARE) {|item| "Forecast#{item}" }

      # 通期予想売上高前年比
      CHANGE_FORECAST_NET_SALES = define_item(NET_SALES) {|item| "ChangeForecast#{item}" }

      # 通期予想営業利益前年比
      CHANGE_FORECAST_OPERATING_INCOME = define_nested_item(OPERATING_INCOME) {|item| "ChangeForecast#{item}" }

      # 通期予想経常利益前年比
      CHANGE_FORECAST_ORDINARY_INCOME = define_item(ORDINARY_INCOME) {|item| "ChangeForecast#{item}" }

      # 通期予想純利益前年比
      CHANGE_FORECAST_NET_INCOME = define_item(NET_INCOME) {|item| "ChangeForecast#{item}" }


      # 修正前通期予想売上高
      FORECAST_PREVIOUS_NET_SALES = define_item(NET_SALES) {|item| "ForecastPrevious#{item}" }

      # 修正前通期予想営業利益
      FORECAST_PREVIOUS_OPERATING_INCOME = define_nested_item(OPERATING_INCOME) {|item| "ForecastPrevious#{item}" }

      # 修正前通期予想経常利益
      FORECAST_PREVIOUS_ORDINARY_INCOME = define_item(ORDINARY_INCOME) {|item| "ForecastPrevious#{item}" }

      # 修正前通期予想純利益
      FORECAST_PREVIOUS_NET_INCOME = define_item(NET_INCOME) {|item| "ForecastPrevious#{item}" }

      # 修正前通期予想一株当たり純利益
      FORECAST_PREVIOUS_NET_INCOME_PER_SHARE = define_item(NET_INCOME_PER_SHARE) {|item| "ForecastPrevious#{item}" }

      # 通期予想売上高増減率
      CHANGE_NET_SALES = define_item(NET_SALES) {|item| "Change#{item}" }

      # 通期予想営業利益増減率
      CHANGE_OPERATING_INCOME = define_nested_item(OPERATING_INCOME) {|item| "Change#{item}" }

      # 通期予想経常利益増減率
      CHANGE_ORDINARY_INCOME = define_item(ORDINARY_INCOME) {|item| "Change#{item}" }

      # 通期予想純利益増減率
      CHANGE_NET_INCOME = define_item(NET_INCOME) {|item| "Change#{item}" }

      # 企業名
      COMPANY_NAME = {
        jp: ['CompanyName'],
        us: ['CompanyName'],
        :if => ['CompanyName']
      }

    end
  end
end