module Flipflop
  module Strategies
    class AbstractStrategy
      module RequestInterceptor
        class << self
          def request
            Thread.current.thread_variable_get(:flipflop_request)
          end

          def request=(request)
            Thread.current.thread_variable_set(:flipflop_request, request)
          end
        end

        extend ActiveSupport::Concern

        included do
          before_action do
            RequestInterceptor.request = request
          end

          after_action do
            RequestInterceptor.request = nil
          end
        end
      end

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
        # TODO: Object ID changes if the feature definitions are reloaded. Maybe
        # we can use the index instead?
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

      protected

      def request
        RequestInterceptor.request or raise "Strategy required request, but was called outside request context."
      end

      def request?
        !RequestInterceptor.request.nil?
      end
    end
  end
end
