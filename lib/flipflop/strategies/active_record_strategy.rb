module Flipflop
  module Strategies
    class ActiveRecordStrategy < AbstractStrategy
      class << self
        def default_description
          "Stores features in database. Applies to all users."
        end
      end

      def initialize(**options)
        super
        @class = options[:class] || Feature
      end

      def switchable?
        true
      end

      def knows?(feature)
        !!find_feature(feature)
      end

      def enabled?(feature)
        find_feature(feature).enabled?
      end

      def switch!(feature, enabled)
        record = @class.where(key: feature.to_s).first_or_initialize
        record.enabled = enabled
        record.save!
      end

      def clear!(feature)
        @class.where(key: feature.to_s).first.try(:destroy)
      end

      private

      def find_feature(feature)
        @class.where(key: feature.to_s).first
      end
    end
  end
end
