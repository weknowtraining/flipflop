module Flipflop
  class FeatureDefinition
    attr_reader :key, :default, :description

    def initialize(key, **options)
      @key = key
      @default = !!options[:default] || false
      @description = options[:description] || key.to_s.humanize + "."
    end

    def name
      key.to_s
    end
  end
end
