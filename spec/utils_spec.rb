require 'spec_helper'

module LiteXBRL
  describe Utils do
    include Utils

    describe '.to_mill' do
      context 'val == nil' do
        let(:val) { nil }
        it { expect(self.class.to_mill val).to be_nil }
      end
    end

  end
end