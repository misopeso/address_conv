require 'spec_helper'

describe AddressConv::Factory::Japan do
  let(:factory) { AddressConv::Factory::Japan.new }

  before(:each) {
    @address = AddressConv::Address::Japan.new
  }

  describe "#parse_prefecture" do
    context "when found 千葉県 in 千葉県千葉市" do
      it "recognize 千葉県" do
        expect(factory.send(:parse_prefecture, @address, "千葉県千葉市中央区")).to eq "千葉市中央区"
        expect(@address.prefecture).to eq "千葉県"
      end
    end

    context "when found 京都府 in 京都府京都市" do
      it "recognize 京都府" do
        expect(factory.send(:parse_prefecture, @address, "京都府京都市北区")).to eq "京都市北区"
        expect(@address.prefecture).to eq "京都府"
      end
    end

    context "when found 東京都 in 東京都府中市" do
      it "recognize 東京都" do
        expect(factory.send(:parse_prefecture, @address, "東京都府中市宮町")).to eq "府中市宮町"
        expect(@address.prefecture).to eq "東京都"
      end
    end
  end

  describe "#parse_municipality" do
    context "when found 千葉市 in 千葉市中央区" do
      it "recognize 千葉市" do
        expect(factory.send(:parse_municipality, @address, "千葉市中央区院内")).to eq "中央区院内"
        expect(@address.municipality).to eq "千葉市"
      end
    end
  end

  describe "#parse_ward" do
    context "when found 中央区 in 中央区院内" do
      it "recognize 中央区" do
        expect(factory.send(:parse_ward, @address, "中央区院内一丁目")).to eq "院内一丁目"
        expect(@address.ward).to eq "中央区"
      end
    end
  end

  describe "#parse_machi & #parse_fragment" do
    before(:each) {
      @address.prefecture = "千葉県"
      @address.municipality = "千葉市"
    }

    context "when found 椿森５丁目 in 中央区椿森５丁目６ー１" do
      it "recognize 椿森５丁目" do
        value = factory.send(:parse_ward, @address, "中央区椿森５丁目６ー１")
        factory.send(:parse_machi, @address, value)

        expect(@address.machi).to eq "椿森"
        expect(@address.act_on_iora).to be_truthy
        expect(@address.city_block).to eq "５"
      end

      it "recognize ６ー１" do
        value = factory.send(:parse_ward, @address, "中央区椿森５丁目６ー１")
        value = factory.send(:parse_machi, @address, value)
        factory.send(:parse_fragment, @address, value)

        expect(@address.building_number).to eq "６"
        expect(@address.apartment_number).to eq "１"
      end
    end

    context "when found 幕張本郷５丁目 in 花見川区幕張本郷５ー８ー３３" do
      it "recognize 幕張本郷５丁目" do
        value = factory.send(:parse_ward, @address, "花見川区幕張本郷５ー８ー３３")
        factory.send(:parse_machi, @address, value)

        expect(@address.machi).to eq "幕張本郷"
        expect(@address.act_on_iora).to be_truthy
        expect(@address.city_block).to eq "５"
      end

      it "recognize ８ー３３" do
        value = factory.send(:parse_ward, @address, "花見川区幕張本郷５ー８ー３３")
        value = factory.send(:parse_machi, @address, value)
        factory.send(:parse_fragment, @address, value)

        expect(@address.building_number).to eq "８"
        expect(@address.apartment_number).to eq "３３"
      end
    end

    context "when found 小深町 in 稲毛区小深町２６１ー７" do
      it "recognize 小深町" do
        value = factory.send(:parse_ward, @address, "稲毛区小深町２６１ー７")
        factory.send(:parse_machi, @address, value)

        expect(@address.machi).to eq "小深町"
        expect(@address.act_on_iora).to be_falsey
      end

      it "recognize ２６１ー７" do
        value = factory.send(:parse_ward, @address, "稲毛区小深町２６１ー７")
        value = factory.send(:parse_machi, @address, value)
        factory.send(:parse_fragment, @address, value)

        expect(@address.land_number).to eq "２６１"
        expect(@address.land_number_extension).to eq "７"
      end
    end
  end
end