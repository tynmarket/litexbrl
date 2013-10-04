module LiteXBRL
  module Utils

    #
    # 証券コードを取得します
    #
    def to_securities_code(elm_code)
      raise StandardError.new("証券コードを取得できません。") unless elm_code

      elm_code.content.slice(0, 4)
    end

    #
    # 会計年度を取得します
    #
    def to_year(elm_end)
      raise StandardError.new("会計年度を取得できません。") unless elm_end

      elm_end.content.split('-')[0].to_i
    end

    #
    # 四半期を取得します
    #
    def to_quarter(elm_end, elm_instant)
      raise StandardError.new("四半期を取得できません。") unless elm_end || elm_instant

      month_end = elm_end.content.split('-')[1].to_i
      month = elm_instant.content.split('-')[1].to_i

      if month <= month_end
        diff = month_end - month

        if diff < 3
          4
        elsif diff < 6
          3
        elsif diff < 9
          2
        else
          1
        end
      else
        diff = month - month_end

        if diff <= 3
          1
        elsif diff <= 6
          2
        elsif diff <= 9
          3
        else
          4
        end
      end
    end

    #
    # 単位を100万円にします
    #
    def to_mill(val)
      val.to_i / (1000 * 1000) if val
    end

    def to_f(val)
      val.to_f if val
    end

  end
end