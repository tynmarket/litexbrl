module LiteXBRL
  module TDnet
    class Summary2 < FinancialInformation2
      include SummaryAttribute, CompanyAttribute

      def self.read(doc)
        xbrl = read_data doc

        {summary: xbrl.attributes,
          results_forecast: [xbrl.attributes_results_forecast]}
      end

      private

      def self.read_data(doc)
        xbrl, context = find_base_data(doc)

        find_data(doc, xbrl, context)
      end

      def self.find_base_data(doc)
        season = find_season(doc)
        consolidation = find_consolidation(doc, season)
        context = context_hash(consolidation, season)

        xbrl = new

        # 証券コード
        xbrl.code = find_securities_code(doc, season)
        # 決算年・決算月
        xbrl.year, xbrl.month = find_year_and_month(doc)
        # 四半期
        xbrl.quarter = to_quarter(season)

        return xbrl, context
      end

      #
      # 通期・四半期を取得します
      #
      def self.find_season(doc)
        q1 = doc.at_xpath("//ix:nonNumeric[@contextRef='CurrentAccumulatedQ1Instant' and @name='tse-ed-t:SecuritiesCode']")
        q2 = doc.at_xpath("//ix:nonNumeric[@contextRef='CurrentAccumulatedQ2Instant' and @name='tse-ed-t:SecuritiesCode']")
        q3 = doc.at_xpath("//ix:nonNumeric[@contextRef='CurrentAccumulatedQ3Instant' and @name='tse-ed-t:SecuritiesCode']")
        year = doc.at_xpath("//ix:nonNumeric[@contextRef='CurrentYearInstant' and @name='tse-ed-t:SecuritiesCode']")

        if q1
          SEASON_Q1
        elsif q2
          SEASON_Q2
        elsif q3
          SEASON_Q3
        elsif year
          SEASON_Q4
        else
          raise StandardError.new("通期・四半期を取得出来ません。")
        end
      end

      #
      # 連結・非連結を取得します
      #
      def self.find_consolidation(doc, season)
        cons = find_value_tse_ed_t(doc, NET_SALES, "Current#{season}Duration_ConsolidatedMember_ResultMember")
        non_cons = find_value_tse_ed_t(doc, NET_SALES, "Current#{season}Duration_NonConsolidatedMember_ResultMember")

        if cons
          "Consolidated"
        elsif non_cons
          "NonConsolidated"
        else
          raise StandardError.new("連結・非連結ともに該当しません。")
        end
      end

      #
      # contextを設定します
      #
      def self.context_hash(consolidation, season)
        year_duration = "YearDuration_#{consolidation}Member_ForecastMember"

        {
          context_duration: "Current#{season}Duration_#{consolidation}Member_ResultMember",
          context_prior_duration: "Prior#{season}Duration_#{consolidation}Member_ResultMember",
          context_instant: "Current#{season}Instant",
          context_forecast: ->(quarter) { quarter == 4 ? "Next#{year_duration}" : "Current#{year_duration}"},
        }
      end

      #
      # 四半期を取得します
      #
      def self.to_quarter(season)
        case season
        when SEASON_Q1
          1
        when SEASON_Q2
          2
        when SEASON_Q3
          3
        when SEASON_Q4
          4
        end
      end

      def self.find_data(doc, xbrl, context)
        # 売上高
        xbrl.net_sales = find_value_to_i(doc, NET_SALES, context[:context_duration])
        # 営業利益
        xbrl.operating_income = find_value_to_i(doc, OPERATING_INCOME, context[:context_duration])
        # 経常利益
        xbrl.ordinary_income = find_value_to_i(doc, ORDINARY_INCOME, context[:context_duration])
        # 純利益
        xbrl.net_income = find_value_to_i(doc, NET_INCOME, context[:context_duration])
        # 1株当たり純利益
        xbrl.net_income_per_share = find_value_to_f(doc, NET_INCOME_PER_SHARE, context[:context_duration])

        # 売上高前年比
        xbrl.change_in_net_sales = find_value_percent_to_f(doc, CHANGE_IN_NET_SALES, context[:context_duration])
        # 営業利益前年比
        xbrl.change_in_operating_income = find_value_percent_to_f(doc, CHANGE_IN_OPERATING_INCOME, context[:context_duration])
        # 経常利益前年比
        xbrl.change_in_ordinary_income = find_value_percent_to_f(doc, CHANGE_IN_ORDINARY_INCOME, context[:context_duration])
        # 純利益前年比
        xbrl.change_in_net_income = find_value_percent_to_f(doc, CHANGE_IN_NET_INCOME, context[:context_duration])

        # 前期売上高
        xbrl.prior_net_sales = find_value_to_i(doc, NET_SALES, context[:context_prior_duration])
        # 前期営業利益
        xbrl.prior_operating_income = find_value_to_i(doc, OPERATING_INCOME, context[:context_prior_duration])
        # 前期経常利益
        xbrl.prior_ordinary_income = find_value_to_i(doc, ORDINARY_INCOME, context[:context_prior_duration])
        # 前期純利益
        xbrl.prior_net_income = find_value_to_i(doc, NET_INCOME, context[:context_prior_duration])
        # 前期1株当たり純利益
        xbrl.prior_net_income_per_share = find_value_to_f(doc, NET_INCOME_PER_SHARE, context[:context_prior_duration])

        # 前期売上高前年比
        xbrl.change_in_prior_net_sales = find_value_percent_to_f(doc, CHANGE_IN_NET_SALES, context[:context_prior_duration])
        # 前期営業利益前年比
        xbrl.change_in_prior_operating_income = find_value_percent_to_f(doc, CHANGE_IN_OPERATING_INCOME, context[:context_prior_duration])
        # 前期経常利益前年比
        xbrl.change_in_prior_ordinary_income = find_value_percent_to_f(doc, CHANGE_IN_ORDINARY_INCOME, context[:context_prior_duration])
        # 前期純利益前年比
        xbrl.change_in_prior_net_income = find_value_percent_to_f(doc, CHANGE_IN_NET_INCOME, context[:context_prior_duration])

        # 通期予想売上高
        xbrl.forecast_net_sales = find_value_to_i(doc, NET_SALES, context[:context_forecast].call(xbrl.quarter))
        # 通期予想営業利益
        xbrl.forecast_operating_income = find_value_to_i(doc, OPERATING_INCOME, context[:context_forecast].call(xbrl.quarter))
        # 通期予想経常利益
        xbrl.forecast_ordinary_income = find_value_to_i(doc, ORDINARY_INCOME, context[:context_forecast].call(xbrl.quarter))
        # 通期予想純利益
        xbrl.forecast_net_income = find_value_to_i(doc, NET_INCOME, context[:context_forecast].call(xbrl.quarter))
        # 通期予想1株当たり純利益
        xbrl.forecast_net_income_per_share = find_value_to_f(doc, NET_INCOME_PER_SHARE, context[:context_forecast].call(xbrl.quarter))

        # 通期予想売上高前年比
        xbrl.change_in_forecast_net_sales = find_value_percent_to_f(doc, CHANGE_IN_NET_SALES, context[:context_forecast].call(xbrl.quarter))
        # 通期予想営業利益前年比
        xbrl.change_in_forecast_operating_income = find_value_percent_to_f(doc, CHANGE_IN_OPERATING_INCOME, context[:context_forecast].call(xbrl.quarter))
        # 通期予想経常利益前年比
        xbrl.change_in_forecast_ordinary_income = find_value_percent_to_f(doc, CHANGE_IN_ORDINARY_INCOME, context[:context_forecast].call(xbrl.quarter))
        # 通期予想純利益前年比
        xbrl.change_in_forecast_net_income = find_value_percent_to_f(doc, CHANGE_IN_NET_INCOME, context[:context_forecast].call(xbrl.quarter))

        xbrl
      end

      def self.find_value_to_i(doc, item, context)
        to_i find_value_tse_ed_t(doc, item, context)
      end

      def self.find_value_to_f(doc, item, context)
        to_f find_value_tse_ed_t(doc, item, context)
      end

      def self.find_value_percent_to_f(doc, item, context)
        percent_to_f find_value_tse_ed_t(doc, item, context)
      end

      def self.parse_company(str)
        doc = Nokogiri::XML str
        xbrl, context = find_base_data(doc)

        # 企業名
        xbrl.company_name = find_value_non_numeric(doc, COMPANY_NAME, context[:context_instant])

        xbrl
      end

    end
  end
end