module Flipflop
  module Strategies
    class SequelStrategy < AbstractStrategy
      class << self
        def default_description
          "Stores features in database. Applies to all users."
        end

        def define_feature_class
          return Flipflop::Feature if defined?(Flipflop::Feature)
          model = Class.new(Sequel::Model(:flipflop_features)).tap do |model|
            model.plugin(:update_or_create)
            model.raise_on_save_failure = true
          end
          Flipflop.const_set(:Feature, model)
        end
      end

      def initialize(**options)
        @class = options.delete(:class) || self.class.define_feature_class
        if !@class.kind_of?(Class)
          @class = ActiveSupport::Inflector.constantize(@class.to_s)
        end
        super(**options)
      end

      def switchable?
        true
      end

      def enabled?(feature)
        find(feature).first.try(:enabled?)
      end

      def switch!(feature, enabled)
        record = find(feature).find_or_new
        record.enabled = enabled
        record.save
      end

      def clear!(feature)
        find(feature).first.try(:destroy)
      end

      protected

      def find(feature)
        @class.where(key: feature.to_s)
      end
    end
  end
end
