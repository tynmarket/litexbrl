require 'spec_helper'

module LiteXBRL
  module TDnet
    describe CompanyAttribute do
      include CompanyAttribute

      describe '#attributes_company' do
        it do
          self.code = "1111"
          self.company_name = "Aaa"
          self.consolidation = 1

          attr = attributes_company

          expect(attr[:code]).to eq "1111"
          expect(attr[:company_name]).to eq "Aaa"
          expect(attr[:consolidation]).to eq 1
        end
      end

    end
  end
end