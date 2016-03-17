module Flipflop
  module Strategies
    class CookieStrategy < AbstractStrategy
      class << self
        def default_description
          "Stores features in a browser cookie. Applies to current user."
        end
      end

      def initialize(**options)
        # TODO: Support :expires as a runtime-evaluated option?
        @options = options.extract!(:path, :domain, :secure, :httponly).freeze
        super(**options)
      end

      def switchable?
        request?
      end

      def enabled?(feature)
        return unless request?
        return unless request.cookie_jar.has_key?(cookie_name(feature))
        cookie = request.cookie_jar[cookie_name(feature)]
        cookie_value = cookie.is_a?(Hash) ? cookie["value"] : cookie
        cookie_value === "1"
      end

      def switch!(feature, enabled)
        value = @options.merge(value: enabled ? "1" : "0")
        request.cookie_jar[cookie_name(feature)] = value
      end

      def clear!(feature)
        request.cookie_jar.delete(cookie_name(feature), **@options)
      end

      protected

      def cookie_name(feature)
        :"flipflop_#{feature}"
      end
    end
  end
end
