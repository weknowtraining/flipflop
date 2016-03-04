module Flipflop
  module Strategies
    class AbstractStrategy
      class << self
        def default_name
          return "anonymous" unless name
          name.split("::").last.gsub(/Strategy$/, "").underscore
        end

        def default_description
        end
      end

      attr_reader :name, :description

      def initialize(**options)
        @name = options[:name] || self.class.default_name
        @description = options[:description] || self.class.default_description
      end

      def key
        object_id.to_s
      end

      def switchable?
        false
      end

      def knows?(feature)
        raise NotImplementedError
      end

      def enabled?(feature)
        raise NotImplementedError
      end

      def switch!(feature, enabled)
        raise NotImplementedError
      end

      def clear!(feature)
        raise NotImplementedError
      end

      def reset!
        raise NotImplementedError
      end
    end
  end
end
