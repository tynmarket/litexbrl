module LiteXBRL
  module TDnet
    module CompanyAttribute
      attr_accessor :code, :company_name, :consolidation

      def attributes_company
        {
          code: code,
          company_name: company_name,
          consolidation: consolidation,
        }
      end

    end
  end
end