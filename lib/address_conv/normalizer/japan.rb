require "moji"

module AddressConv
  module Normalizer
    class Japan
      def normalize(value)
        value = chinese_to_number(value)
        value = Moji.han_to_zen(value, Moji::HAN_NUMBER | Moji::HAN_KATA)
        value = normalize_hyphen(value)
      end

      private

      CHINESE_NUM = {
        '〇' => 0, '一' => 1, '二' => 2, '三' => 3, '四' => 4, '五' => 5, '六' => 6,
        '七' => 7, '八' => 8, '九' => 9
      }

      def chinese_to_number(value)
        chunks = []

        while !value.nil? && data = value.match(/[一二三四五六七八九〇]+/) do
          chunks << data.pre_match
          chunks << data[0].chars.map { |c| CHINESE_NUM[c] }.join
          value = data.post_match
        end

        chunks << value unless value.nil?

        chunks.join
      end

      HYPHENS = [ '\u002D', '\u2014', '\u2212', '\u30FC', '\uFF70']
      NORMALIZED_HYPHEN = "\u30FC"

      def normalize_hyphen(value)
        value.gsub(/[#{HYPHENS.join}]/, NORMALIZED_HYPHEN)
      end
    end
  end
end
