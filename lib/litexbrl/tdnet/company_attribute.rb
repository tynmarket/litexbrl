module LiteXBRL
  module TDnet
    module CompanyAttribute
      attr_accessor :code, :company_name

      def attributes_company
        {
          code: code,
          company_name: company_name
        }
      end

    end
  end
end