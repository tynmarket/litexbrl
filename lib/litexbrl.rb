$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

require 'litexbrl/version'
require 'litexbrl/utils'
require 'litexbrl/tdnet'

module LiteXBRL

  class << self

    def parse(path)
      doc = find_document(path)

      xbrl = doc.parse(path)
    end

    private

    def find_document(path)
      TDnet::Summary
    end

  end

end