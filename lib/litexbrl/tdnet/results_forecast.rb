module LiteXBRL
  module TDnet
    class ResultsForecast < FinancialInformation
      include ResultsForecastAttribute

      SEASON_Q2 = 'AccumulatedQ2'
      SEASON_Q4 = 'Year'

      def self.read(doc)
        xbrl_q2 = read_data doc, SEASON_Q2
        xbrl_q4 = read_data doc, SEASON_Q4

        raise StandardError.new "業績予想の修正を取得できません。" unless xbrl_q2 || xbrl_q4

        data = {results_forecast: []}
        data[:results_forecast] << xbrl_q2.attributes if xbrl_q2
        data[:results_forecast] << xbrl_q4.attributes if xbrl_q4

        data
      end

      private

      def self.read_data(doc, season)
        xbrl, context = find_base_data(doc, season)

        find_data(doc, xbrl, context)
      end

      def self.find_base_data(doc, season)
        consolidation = find_consolidation(doc)
        context = context_hash(consolidation, season)

        xbrl = new

        # 証券コード
        xbrl.code = find_securities_code(doc, consolidation)
        # 決算年
        xbrl.year = find_year(doc, consolidation)
        # 決算月
        xbrl.month = find_month(doc, consolidation)
        # 四半期
        xbrl.quarter = season == SEASON_Q2 ? 2 : 4

        return xbrl, context
      end

      def self.find_data(doc, xbrl, context)
        # 通期/第2四半期予想売上高
        xbrl.forecast_net_sales = to_mill find_value_ed(doc, FORECAST_NET_SALES, context)
        # 通期/第2四半期予想営業利益
        xbrl.forecast_operating_income = to_mill find_value_ed(doc, FORECAST_OPERATING_INCOME, context)
        # 通期/第2四半期予想経常利益
        xbrl.forecast_ordinary_income = to_mill find_value_ed(doc, FORECAST_ORDINARY_INCOME, context)
        # 通期/第2四半期予想純利益
        xbrl.forecast_net_income = to_mill find_value_ed(doc, FORECAST_NET_INCOME, context)
        # 通期/第2四半期予想1株当たり純利益
        xbrl.forecast_net_income_per_share = to_f find_value_ed(doc, FORECAST_NET_INCOME_PER_SHARE, context)

        # 修正前通期/第2四半期予想売上高
        xbrl.previous_forecast_net_sales = to_mill find_value_rv(doc, PREVIOUS_FORECAST_NET_SALES, context)
        # 修正前通期/第2四半期予想営業利益
        xbrl.previous_forecast_operating_income = to_mill find_value_rv(doc, PREVIOUS_FORECAST_OPERATING_INCOME, context)
        # 修正前通期/第2四半期予想経常利益
        xbrl.previous_forecast_ordinary_income = to_mill find_value_rv(doc, PREVIOUS_FORECAST_ORDINARY_INCOME, context)
        # 修正前通期/第2四半期予想純利益
        xbrl.previous_forecast_net_income = to_mill find_value_rv(doc, PREVIOUS_FORECAST_NET_INCOME, context)
        # 修正前通期/第2四半期予想1株当たり純利益
        xbrl.previous_forecast_net_income_per_share = to_f find_value_rv(doc, PREVIOUS_FORECAST_NET_INCOME_PER_SHARE, context)

        # 通期/第2四半期予想売上高増減率
        xbrl.change_forecast_net_sales = to_f find_value_rv(doc, CHANGE_NET_SALES, context)
        # 通期/第2四半期予想営業利益増減率
        xbrl.change_forecast_operating_income = to_f find_value_rv(doc, CHANGE_OPERATING_INCOME, context)
        # 通期/第2四半期予想経常利益増減率
        xbrl.change_forecast_ordinary_income = to_f find_value_rv(doc, CHANGE_ORDINARY_INCOME, context)
        # 通期/第2四半期予想純利益増減率
        xbrl.change_forecast_net_income = to_f find_value_rv(doc, CHANGE_NET_INCOME, context)

        xbrl
      end

      def self.find_value_ed(doc, item, context)
        find_value_tse_t_ed(doc, item, context[:context_duration])
      end

      def self.find_value_rv(doc, item, context)
        find_value_tse_t_rv(doc, item, context[:context_duration])
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