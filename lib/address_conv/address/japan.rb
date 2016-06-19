module AddressConv
  module Address
    class Japan
      attr_accessor :prefecture
      attr_accessor :prefecture_code
      attr_accessor :municipality
      attr_accessor :municipality_code
      attr_accessor :ward
      attr_accessor :machi
      attr_accessor :machi_code
      attr_accessor :city_block
      attr_accessor :building_number
      attr_accessor :apartment_number
      attr_accessor :land_number
      attr_accessor :land_number_extension
      attr_accessor :act_on_iora

      def to_s
        "#{prefecture}#{minicipality}#{ward}#{machi}#{street_address}"
      end

      def street_address
        if act_on_iora
          "#{city_block}丁目#{building_number}ー#{apartment_number}"
        else
          "#{land_number}番地#{land_number_extension}"
        end
      end
    end
  end
end