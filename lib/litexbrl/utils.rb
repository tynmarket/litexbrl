module LiteXBRL
  module Utils

    def hash_with_default(default, hash)
      hash.default = default
      hash
    end

    #
    # 証券コードを取得します
    #
    def to_securities_code(elm_code)
      raise StandardError.new("証券コードを取得できません。") unless elm_code

      elm_code.content.slice(0, 4).tr("０-９", "0-9")
    end

    #
    # 決算年を取得します
    #
    def to_year(elm_end)
      raise StandardError.new("決算年を取得できません。") unless elm_end

      elm_end.content.split('-')[0].to_i
    end

    #
    # 決算月を取得します
    #
    def to_month(elm_end)
      raise StandardError.new("決算月を取得できません。") unless elm_end

      elm_end.content.split('-')[1].to_i
    end

    #
    # 単位を100万円にします
    #
    def to_mill(val)
      val.to_i / (1000 * 1000) if present? val
    end

    def to_i(val)
      val.delete(',').to_i if present? val
    end

    def to_f(val)
      val.delete(',').to_f if present? val
    end

    def percent_to_f(val)
      (to_f(val) / 100).round(3) if present? val
    end

    def present?(val)
      !!(val && val != "")
    end

  end
end