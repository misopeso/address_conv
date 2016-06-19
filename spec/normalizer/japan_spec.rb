require 'spec_helper'

describe AddressConv::Normalizer::Japan do
  let(:normalizer) { AddressConv::Normalizer::Japan.new }

  describe "#chinese_to_number" do
    context "when found chinese numeral" do
      it "is only chinese numeral" do
        expect(normalizer.send(:chinese_to_number, "四")).to eq "4"
      end

      it "has chinese numeral with other chars" do
        expect(normalizer.send(:chinese_to_number, "青葉町一二三七")).to eq "青葉町1237"
      end

      it "has multipul chinese numeral" do
        expect(normalizer.send(:chinese_to_number, "青葉町九五五ー二")).to eq "青葉町955ー2"
      end
    end
  end
end
