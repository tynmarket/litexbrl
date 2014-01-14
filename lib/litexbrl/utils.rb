module LiteXBRL
  module Utils

    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def hash_with_default(default, hash)
        hash.default = default
        hash
      end

      #
      # 証券コードを取得します
      #
      def to_securities_code(elm_code)
        raise StandardError.new("証券コードを取得できません。") unless elm_code

        elm_code.content.slice(0, 4)
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
      # 四半期を取得します
      #
      def to_quarter2(season)
        case season
        when "AccumulatedQ1"
          1
        when "AccumulatedQ2"
          2
        when "AccumulatedQ3"
          3
        when "Year"
          4
        end
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
        val.to_f if present? val
      end

      def percent_to_f(val)
        (val.to_f / 100).round(3) if present? val
      end

      def present?(val)
        val && val != ""
      end
    end

  end
end