module LiteXBRL
  module TDnet
    class Summary < FinancialInformation
      include SummaryAttribute

      def self.find_data(doc, xbrl, accounting_base, context)
        # 売上高
        xbrl.net_sales = to_mill(find_value_tse_t_ed(doc, NET_SALES[accounting_base], context[:context_duration]))
        # 営業利益
        xbrl.operating_income = to_mill(find_value_tse_t_ed(doc, OPERATING_INCOME[accounting_base], context[:context_duration]))
        # 経常利益
        xbrl.ordinary_income = to_mill(find_value_tse_t_ed(doc, ORDINARY_INCOME[accounting_base], context[:context_duration]))
        # 純利益
        xbrl.net_income = to_mill(find_value_tse_t_ed(doc, NET_INCOME[accounting_base], context[:context_duration]))
        # 1株当たり純利益
        xbrl.net_income_per_share = to_f(find_value_tse_t_ed(doc, NET_INCOME_PER_SHARE[accounting_base], context[:context_duration]))

        # 売上高前年比
        xbrl.change_in_net_sales = to_f(find_value_tse_t_ed(doc, CHANGE_IN_NET_SALES[accounting_base], context[:context_duration]))
        # 営業利益前年比
        xbrl.change_in_operating_income = to_f(find_value_tse_t_ed(doc, CHANGE_IN_OPERATING_INCOME[accounting_base], context[:context_duration]))
        # 経常利益前年比
        xbrl.change_in_ordinary_income = to_f(find_value_tse_t_ed(doc, CHANGE_IN_ORDINARY_INCOME[accounting_base], context[:context_duration]))
        # 純利益前年比
        xbrl.change_in_net_income = to_f(find_value_tse_t_ed(doc, CHANGE_IN_NET_INCOME[accounting_base], context[:context_duration]))

        # 通期予想売上高
        xbrl.forecast_net_sales = to_mill(find_value_tse_t_ed(doc, FORECAST_NET_SALES[accounting_base], context[:context_forecast].call(xbrl.quarter)))
        # 通期予想営業利益
        xbrl.forecast_operating_income = to_mill(find_value_tse_t_ed(doc, FORECAST_OPERATING_INCOME[accounting_base], context[:context_forecast].call(xbrl.quarter)))
        # 通期予想経常利益
        xbrl.forecast_ordinary_income = to_mill(find_value_tse_t_ed(doc, FORECAST_ORDINARY_INCOME[accounting_base], context[:context_forecast].call(xbrl.quarter)))
        # 通期予想純利益
        xbrl.forecast_net_income = to_mill(find_value_tse_t_ed(doc, FORECAST_NET_INCOME[accounting_base], context[:context_forecast].call(xbrl.quarter)))
        # 通期予想1株当たり純利益
        xbrl.forecast_net_income_per_share = to_f(find_value_tse_t_ed(doc, FORECAST_NET_INCOME_PER_SHARE[accounting_base], context[:context_forecast].call(xbrl.quarter)))

        # 通期予想売上高前年比
        xbrl.change_in_forecast_net_sales = to_f(find_value_tse_t_ed(doc, CHANGE_FORECAST_NET_SALES[accounting_base], context[:context_forecast].call(xbrl.quarter)))
        # 通期予想営業利益前年比
        xbrl.change_in_forecast_operating_income = to_f(find_value_tse_t_ed(doc, CHANGE_FORECAST_OPERATING_INCOME[accounting_base], context[:context_forecast].call(xbrl.quarter)))
        # 通期予想経常利益前年比
        xbrl.change_in_forecast_ordinary_income = to_f(find_value_tse_t_ed(doc, CHANGE_FORECAST_ORDINARY_INCOME[accounting_base], context[:context_forecast].call(xbrl.quarter)))
        # 通期予想純利益前年比
        xbrl.change_in_forecast_net_income = to_f(find_value_tse_t_ed(doc, CHANGE_FORECAST_NET_INCOME[accounting_base], context[:context_forecast].call(xbrl.quarter)))

        xbrl
      end

      def self.find_accounting_base(doc, context, quarter)
        namespace = doc.namespaces.keys.find {|ns| ns.start_with? 'xmlns:tdnet' }

        case namespace
        when /.+jpsm.+/
          :jp
        when /.+ussm.+/
          :us
        when /.+ifsm.+/
          :if
        else
          :jp
        end
      end

    end
  end
end