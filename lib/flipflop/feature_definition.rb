module Flipflop
  class FeatureDefinition
    attr_reader :key, :name, :title, :description, :default, :group

    def initialize(key, **options)
      @key = key
      @name = @key.to_s.freeze
      @title = @name.humanize.freeze
      @description = options.delete(:description).freeze
      @default = !!options.delete(:default) || false
      @group = options.delete(:group).freeze
    end
  end
end
