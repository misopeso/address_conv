require 'spec_helper'

describe AddressConv do
  it 'has a version number' do
    expect(AddressConv::Version::STRING).not_to be nil
  end

  describe "#parse" do
    context "with full-width numeral and iora" do
      it "correctly recognize" do
        a = AddressConv.parse("千葉県千葉市若葉区御成台３ー１１６８−２２")

        expect(a.prefecture).to eq "千葉県"
        expect(a.municipality).to eq "千葉市"
        expect(a.ward).to eq "若葉区"
        expect(a.machi).to eq "御成台"
        expect(a.city_block).to eq "３"
        expect(a.building_number).to eq "１１６８"
        expect(a.apartment_number).to eq "２２"
      end
    end

    context "with full-width numeral with cho-me style and iora" do
      it "correctly recognize" do
        a = AddressConv.parse("千葉県千葉市若葉区西都賀４丁目２０")

        expect(a.prefecture).to eq "千葉県"
        expect(a.municipality).to eq "千葉市"
        expect(a.ward).to eq "若葉区"
        expect(a.machi).to eq "西都賀"
        expect(a.city_block).to eq "４"
        expect(a.building_number).to eq "２０"
      end
    end

    context "with full-width numeral and non-iora" do
      it "correctly recognize" do
        a = AddressConv.parse("千葉県千葉市緑区おゆみ野有吉３０−１０")

        expect(a.prefecture).to eq "千葉県"
        expect(a.municipality).to eq "千葉市"
        expect(a.ward).to eq "緑区"
        expect(a.machi).to eq "おゆみ野有吉"
        expect(a.land_number).to eq "３０"
        expect(a.land_number_extension).to eq "１０"
      end
    end

    context "with chinese numeral and iora" do
      it "correctly recognize" do
        a = AddressConv.parse("千葉県千葉市稲毛区緑町二ー二")

        expect(a.prefecture).to eq "千葉県"
        expect(a.municipality).to eq "千葉市"
        expect(a.ward).to eq "稲毛区"
        expect(a.machi).to eq "緑町"
        expect(a.city_block).to eq "２"
        expect(a.building_number).to eq "２"
      end
    end

    context "with chinese numeral with cho-me style and iora" do
      it "correctly recognize" do
        a = AddressConv.parse("千葉県千葉市稲毛区稲毛東四丁目１２−２")

        expect(a.prefecture).to eq "千葉県"
        expect(a.municipality).to eq "千葉市"
        expect(a.ward).to eq "稲毛区"
        expect(a.machi).to eq "稲毛東"
        expect(a.city_block).to eq "４"
        expect(a.building_number).to eq "１２"
        expect(a.apartment_number).to eq "２"
      end
    end

    context "with chinese numeral and non-iora" do
      it "correctly recognize" do
        a = AddressConv.parse("千葉県千葉市花見川区花島町六〇")

        expect(a.prefecture).to eq "千葉県"
        expect(a.municipality).to eq "千葉市"
        expect(a.ward).to eq "花見川区"
        expect(a.machi).to eq "花島町"
        expect(a.land_number).to eq "６０"
      end
    end

    context "with half-width numeral and iora" do
      it "correctly recognize" do
        a = AddressConv.parse("千葉県千葉市中央区葛城1-6-1")

        expect(a.prefecture).to eq "千葉県"
        expect(a.municipality).to eq "千葉市"
        expect(a.ward).to eq "中央区"
        expect(a.machi).to eq "葛城"
        expect(a.city_block).to eq "１"
        expect(a.building_number).to eq "６"
        expect(a.apartment_number).to eq "１"
      end
    end

    context "with half-width numeral with cho-me style and iora" do
      it "correctly recognize" do
        a = AddressConv.parse("千葉県千葉市中央区松波2丁目-10-1")

        expect(a.prefecture).to eq "千葉県"
        expect(a.municipality).to eq "千葉市"
        expect(a.ward).to eq "中央区"
        expect(a.machi).to eq "松波"
        expect(a.city_block).to eq "２"
        expect(a.building_number).to eq "１０"
        expect(a.apartment_number).to eq "１"
      end
    end

    context "with half-width numeral and non iora" do
      it "correctly recognize" do
        a = AddressConv.parse("千葉県千葉市美浜区豊砂1-4")

        expect(a.prefecture).to eq "千葉県"
        expect(a.municipality).to eq "千葉市"
        expect(a.ward).to eq "美浜区"
        expect(a.machi).to eq "豊砂"
        expect(a.land_number).to eq "１"
        expect(a.land_number_extension).to eq "４"
      end
    end
  end
end
