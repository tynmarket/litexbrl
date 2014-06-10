module LiteXBRL
  module TDnet
    class Summary < FinancialInformation
      include SummaryAttribute

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
        consolidation, season = find_consolidation_and_season(doc)
        context = context_hash(consolidation, season)

        xbrl = new

        # 証券コード
        xbrl.code = find_securities_code(doc, consolidation)
        # 決算年
        xbrl.year = find_year(doc, consolidation)
        # 決算月
        xbrl.month = find_month(doc, consolidation)
        # 四半期
        xbrl.quarter = find_quarter(doc, consolidation, context)

        return xbrl, context
      end

      def self.find_consolidation_and_season(doc)
        consolidation = find_consolidation(doc)
        season = find_season(doc, consolidation)

        # 連結で取れない場合、非連結にする
        unless season
          consolidation = "NonConsolidated"
          season = find_season(doc, consolidation)
        end

        return consolidation, season
      end

      #
      # 通期・四半期を取得します
      #
      def self.find_season(doc, consolidation)
        year = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentYear#{consolidation}Instant']/xbrli:entity/xbrli:identifier")
        quarter = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentQuarter#{consolidation}Instant']/xbrli:entity/xbrli:identifier")
        q1 = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentAccumulatedQ1#{consolidation}Instant']/xbrli:entity/xbrli:identifier")
        q2 = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentAccumulatedQ2#{consolidation}Instant']/xbrli:entity/xbrli:identifier")
        q3 = doc.at_xpath("//xbrli:xbrl/xbrli:context[@id='CurrentAccumulatedQ3#{consolidation}Instant']/xbrli:entity/xbrli:identifier")

        if year
          "Year"
        elsif quarter
          "Quarter"
        elsif q1
          "AccumulatedQ1"
        elsif q2
          "AccumulatedQ2"
        elsif q3
          "AccumulatedQ3"
        end
      end

      def self.find_data(doc, xbrl, context)
        # 売上高
        xbrl.net_sales = to_mill(find_value_tse_t_ed(doc, NET_SALES, context[:context_duration]))
        # 営業利益
        xbrl.operating_income = to_mill(find_value_tse_t_ed(doc, OPERATING_INCOME, context[:context_duration]))
        # 経常利益
        xbrl.ordinary_income = to_mill(find_value_tse_t_ed(doc, ORDINARY_INCOME, context[:context_duration]))
        # 純利益
        xbrl.net_income = to_mill(find_value_tse_t_ed(doc, NET_INCOME, context[:context_duration]))
        # 1株当たり純利益
        xbrl.net_income_per_share = to_f(find_value_tse_t_ed(doc, NET_INCOME_PER_SHARE, context[:context_duration]))

        # 売上高前年比
        xbrl.change_in_net_sales = to_f(find_value_tse_t_ed(doc, CHANGE_IN_NET_SALES, context[:context_duration]))
        # 営業利益前年比
        xbrl.change_in_operating_income = to_f(find_value_tse_t_ed(doc, CHANGE_IN_OPERATING_INCOME, context[:context_duration]))
        # 経常利益前年比
        xbrl.change_in_ordinary_income = to_f(find_value_tse_t_ed(doc, CHANGE_IN_ORDINARY_INCOME, context[:context_duration]))
        # 純利益前年比
        xbrl.change_in_net_income = to_f(find_value_tse_t_ed(doc, CHANGE_IN_NET_INCOME, context[:context_duration]))

        # 前期売上高
        xbrl.prior_net_sales = to_mill(find_value_tse_t_ed(doc, NET_SALES, context[:context_prior_duration]))
        # 前期営業利益
        xbrl.prior_operating_income = to_mill(find_value_tse_t_ed(doc, OPERATING_INCOME, context[:context_prior_duration]))
        # 前期経常利益
        xbrl.prior_ordinary_income = to_mill(find_value_tse_t_ed(doc, ORDINARY_INCOME, context[:context_prior_duration]))
        # 前期純利益
        xbrl.prior_net_income = to_mill(find_value_tse_t_ed(doc, NET_INCOME, context[:context_prior_duration]))
        # 前期1株当たり純利益
        xbrl.prior_net_income_per_share = to_f(find_value_tse_t_ed(doc, NET_INCOME_PER_SHARE, context[:context_prior_duration]))

        # 前期売上高前年比
        xbrl.change_in_prior_net_sales = to_f(find_value_tse_t_ed(doc, CHANGE_IN_NET_SALES, context[:context_prior_duration]))
        # 前期営業利益前年比
        xbrl.change_in_prior_operating_income = to_f(find_value_tse_t_ed(doc, CHANGE_IN_OPERATING_INCOME, context[:context_prior_duration]))
        # 前期経常利益前年比
        xbrl.change_in_prior_ordinary_income = to_f(find_value_tse_t_ed(doc, CHANGE_IN_ORDINARY_INCOME, context[:context_prior_duration]))
        # 前期純利益前年比
        xbrl.change_in_prior_net_income = to_f(find_value_tse_t_ed(doc, CHANGE_IN_NET_INCOME, context[:context_prior_duration]))

        # 通期予想売上高
        xbrl.forecast_net_sales = to_mill(find_value_tse_t_ed(doc, FORECAST_NET_SALES, context[:context_forecast].call(xbrl.quarter)))
        # 通期予想営業利益
        xbrl.forecast_operating_income = to_mill(find_value_tse_t_ed(doc, FORECAST_OPERATING_INCOME, context[:context_forecast].call(xbrl.quarter)))
        # 通期予想経常利益
        xbrl.forecast_ordinary_income = to_mill(find_value_tse_t_ed(doc, FORECAST_ORDINARY_INCOME, context[:context_forecast].call(xbrl.quarter)))
        # 通期予想純利益
        xbrl.forecast_net_income = to_mill(find_value_tse_t_ed(doc, FORECAST_NET_INCOME, context[:context_forecast].call(xbrl.quarter)))
        # 通期予想1株当たり純利益
        xbrl.forecast_net_income_per_share = to_f(find_value_tse_t_ed(doc, FORECAST_NET_INCOME_PER_SHARE, context[:context_forecast].call(xbrl.quarter)))

        # 通期予想売上高前年比
        xbrl.change_in_forecast_net_sales = to_f(find_value_tse_t_ed(doc, CHANGE_FORECAST_NET_SALES, context[:context_forecast].call(xbrl.quarter)))
        # 通期予想営業利益前年比
        xbrl.change_in_forecast_operating_income = to_f(find_value_tse_t_ed(doc, CHANGE_FORECAST_OPERATING_INCOME, context[:context_forecast].call(xbrl.quarter)))
        # 通期予想経常利益前年比
        xbrl.change_in_forecast_ordinary_income = to_f(find_value_tse_t_ed(doc, CHANGE_FORECAST_ORDINARY_INCOME, context[:context_forecast].call(xbrl.quarter)))
        # 通期予想純利益前年比
        xbrl.change_in_forecast_net_income = to_f(find_value_tse_t_ed(doc, CHANGE_FORECAST_NET_INCOME, context[:context_forecast].call(xbrl.quarter)))

        xbrl
      end

    end
  end
end