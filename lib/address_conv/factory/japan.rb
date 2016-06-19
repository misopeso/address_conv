require "address_conv/address/japan"
require "csv"
require "moji"

module AddressConv
  module Factory
    class Japan
      def initialize
        @@machi = CSV.read(File.expand_path('../../../../data/machi.csv', __FILE__))
      end

      def create(value, options = {})
        address = AddressConv::Address::Japan.new

        value = parse_prefecture(address, value, options)
        value = parse_municipality(address, value, options)
        value = parse_ward(address, value)
        value = parse_machi(address, value)
        parse_fragment(address, value)

        address
      end

      private

      def parse_prefecture(address, value, options = {})
        if options.has_key? :prefecture
          address.prefecture = options[:prefecture]
        else
          if md = value.match(/(...??[都道府県])/)
            address.prefecture = md[1]
            value = value.slice(md[1].size..-1)
          else
            raise NotFoundError, "Prefecture not found"
          end
        end

        value
      end

      def parse_municipality(address, value, options = {})
        if options.has_key? :minicipality
          address.municipality = options[:minicipality]
        else
          if md = value.match(/(.+?[市町村])/)
            address.municipality = md[1]
            value = value.slice(md[1].size..-1)
          else
            raise NotFoundError, "Municipality not found"
          end
        end

        value
      end

      def parse_ward(address, value)
        if md = value.match(/(.+?区)/)
          address.ward = md[1]
          value = value.slice(md[1].size..-1)
        end

        value
      end

      def parse_machi(address, value)
        machi = search_machi(address, value)

        unless machi.nil?
          address.prefecture_code = machi[0]
          address.municipality_code = machi[2]
          address.machi_code = machi[5]

          if machi[10] == "3"
            md = machi[6].match(/(.*)(#{Moji.zen_number}+)丁目/)
            address.machi = md[1]
            address.city_block = md[2]
            address.act_on_iora = true

            if value.match(/#{machi[6]}/)
              value = value.slice(machi[6].size..-1)
            else
              value = value.slice(machi[6].gsub(/丁目/, "\u30FC").size..-1)
            end
          else
            address.machi = machi[6]
            address.act_on_iora = false
            value = value.slice(machi[6].size..-1)
          end
        else
          raise NotFoundError, "Machi not found"
        end

        value
      end

      def parse_fragment(address, value)
        if address.act_on_iora
          if md = value.match(/(#{Moji.zen_number}+)(?:\u30FC(#{Moji.zen_number}*))?/)
            address.building_number = md[1]
            address.apartment_number = md[2]
          end
        else
          if md = value.match(/(#{Moji.zen_number}+)(?:\u30FC(#{Moji.zen_number}*))?/)
            address.land_number = md[1]
            address.land_number_extension = md[2]
          end
        end
      end

      def search_machi(address, value)
        list = machi_list(address)
        machi = list.select { |m| value.match /^#{m[6]}/ }.first

        if machi.nil?
          machi = list.select do |m|
            keyword = m[6].gsub(/丁目/, "")
            value.match /^#{keyword}/
          end.first
        end

        machi
      end

      def machi_list(address)
        @@machi.select do |m|
          m[1] == address.prefecture &&
            m[3] == address.municipality &&
            m[4] == address.ward
        end
      end
    end
  end
end

