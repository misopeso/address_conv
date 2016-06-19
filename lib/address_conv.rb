require "address_conv/version"
require "address_conv/normalizer/japan"
require "address_conv/factory/japan"

module AddressConv
  class << self
    def parse(value)
      value = normalizer.normalize(value)
      factory.create(value)
    end

    private

    def normalizer
      Normalizer::Japan.new
    end

    def factory
      Factory::Japan.new
    end
  end

  class NotFoundError < StandardError; end
end

