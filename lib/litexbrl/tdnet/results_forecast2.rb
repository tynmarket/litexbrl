module LiteXBRL
  module TDnet
    class ResultsForecast2 < FinancialInformation2
      include ResultsForecastAttribute

      def self.read(doc)
        xbrl_q2 = read_data doc, SEASON_Q2
        xbrl_q4 = read_data doc, SEASON_Q4

        unless xbrl_q2 || xbrl_q4
          xbrl_q1 = read_data doc, SEASON_Q1
          xbrl_q3 = read_data doc, SEASON_Q3 unless xbrl_q1

          raise StandardError.new "業績予想の修正を取得できません。" unless xbrl_q1 || xbrl_q3
        end

        data = {results_forecast: []}
        data[:results_forecast] << xbrl_q1.attributes if xbrl_q1
        data[:results_forecast] << xbrl_q2.attributes if xbrl_q2
        data[:results_forecast] << xbrl_q3.attributes if xbrl_q3
        data[:results_forecast] << xbrl_q4.attributes if xbrl_q4

        data
      end

      private

      def self.read_data(doc, season)
        consolidation = find_consolidation(doc, season, NET_SALES)
        consolidation = find_consolidation(doc, season, OPERATING_INCOME) unless consolidation
        consolidation = find_consolidation(doc, season, ORDINARY_INCOME) unless consolidation
        consolidation = find_consolidation(doc, season, NET_INCOME) unless consolidation
        consolidation = find_consolidation(doc, season, NET_INCOME_PER_SHARE) unless consolidation
        consolidation = find_consolidation_range(doc, season, NET_SALES) unless consolidation
        consolidation = find_consolidation_range(doc, season, OPERATING_INCOME) unless consolidation
        consolidation = find_consolidation_range(doc, season, ORDINARY_INCOME) unless consolidation
        consolidation = find_consolidation_range(doc, season, NET_INCOME) unless consolidation
        consolidation = find_consolidation_range(doc, season, NET_INCOME_PER_SHARE) unless consolidation

        return unless consolidation

        xbrl,context = find_base_data(doc, consolidation, season)

        find_data(doc, xbrl, context)
      end

      def self.find_consolidation(doc, season, item)
        cons_current = present? find_value_tse_ed_t(doc, item, "Current#{season}Duration_ConsolidatedMember_CurrentMember_ForecastMember")
        cons_prev = present? find_value_tse_ed_t(doc, item, "Current#{season}Duration_ConsolidatedMember_PreviousMember_ForecastMember")
        non_cons_current = present? find_value_tse_ed_t(doc, item, "Current#{season}Duration_NonConsolidatedMember_CurrentMember_ForecastMember")
        non_cons_prev = present? find_value_tse_ed_t(doc, item, "Current#{season}Duration_NonConsolidatedMember_PreviousMember_ForecastMember")

        if cons_current || cons_prev
          "Consolidated"
        elsif non_cons_current || non_cons_prev
          "NonConsolidated"
        end
      end

      def self.find_consolidation_range(doc, season, item)
        cons_current = present? find_value_tse_ed_t(doc, item, "Current#{season}Duration_ConsolidatedMember_CurrentMember_UpperMember")
        cons_prev = present? find_value_tse_ed_t(doc, item, "Current#{season}Duration_ConsolidatedMember_PreviousMember_UpperMember")
        non_cons_current = present? find_value_tse_ed_t(doc, item, "Current#{season}Duration_NonConsolidatedMember_CurrentMember_UpperMember")
        non_cons_prev = present? find_value_tse_ed_t(doc, item, "Current#{season}Duration_NonConsolidatedMember_PreviousMember_UpperMember")

        if cons_current || cons_prev
          "Consolidated"
        elsif non_cons_current || non_cons_prev
          "NonConsolidated"
        end
      end

      def self.context_hash(consolidation, season)
        {
          context_current_forecast: "Current#{season}Duration_#{consolidation}Member_CurrentMember_ForecastMember",
          context_prev_forecast: "Current#{season}Duration_#{consolidation}Member_PreviousMember_ForecastMember",
        }
      end

      def self.find_base_data(doc, consolidation, season)
        context = context_hash(consolidation, season)
        xbrl = new

        # 証券コード
        xbrl.code = find_securities_code(doc, SEASON_Q4)
        # 決算年・決算月
        xbrl.year, xbrl.month = find_year_and_month(doc)
        # 四半期
        xbrl.quarter = to_quarter season
        # 連結・非連結
        xbrl.consolidation = to_consolidation(consolidation)

        return xbrl, context
      end

      def self.find_data(doc, xbrl, context)
        # 通期/第2四半期予想売上高
        xbrl.forecast_net_sales = to_i current_value(doc, NET_SALES, context)
        # 通期/第2四半期予想営業利益
        xbrl.forecast_operating_income = to_i current_value(doc, OPERATING_INCOME, context)
        # 通期/第2四半期予想経常利益
        xbrl.forecast_ordinary_income = to_i current_value(doc, ORDINARY_INCOME, context)
        # 通期/第2四半期予想純利益
        xbrl.forecast_net_income = to_i current_value(doc, NET_INCOME, context)
        # 通期/第2四半期予想1株当たり純利益
        xbrl.forecast_net_income_per_share = to_f current_value(doc, NET_INCOME_PER_SHARE, context)

        # 修正前通期/第2四半期予想売上高
        xbrl.previous_forecast_net_sales = to_i prev_value(doc, NET_SALES, context)
        # 修正前通期/第2四半期予想営業利益
        xbrl.previous_forecast_operating_income = to_i prev_value(doc, OPERATING_INCOME, context)
        # 修正前通期/第2四半期予想経常利益
        xbrl.previous_forecast_ordinary_income = to_i prev_value(doc, ORDINARY_INCOME, context)
        # 修正前通期/第2四半期予想純利益
        xbrl.previous_forecast_net_income = to_i prev_value(doc, NET_INCOME, context)
        # 修正前通期/第2四半期予想1株当たり純利益
        xbrl.previous_forecast_net_income_per_share = to_f prev_value(doc, NET_INCOME_PER_SHARE, context)

        # 通期/第2四半期予想売上高増減率
        xbrl.change_forecast_net_sales = percent_to_f current_value(doc, CHANGE_IN_NET_SALES, context)
        # 通期/第2四半期予想営業利益増減率
        xbrl.change_forecast_operating_income = percent_to_f current_value(doc, CHANGE_IN_OPERATING_INCOME, context)
        # 通期/第2四半期予想経常利益増減率
        xbrl.change_forecast_ordinary_income = percent_to_f current_value(doc, CHANGE_IN_ORDINARY_INCOME, context)
        # 通期/第2四半期予想純利益増減率
        xbrl.change_forecast_net_income = percent_to_f current_value(doc, CHANGE_IN_NET_INCOME, context)

        xbrl
      end

      def self.current_value(doc, item, context)
        find_value_tse_ed_t(doc, item, context[:context_current_forecast])
      end

      def self.prev_value(doc, item, context)
        find_value_tse_ed_t(doc, item, context[:context_prev_forecast])
      end

    end
  end
end