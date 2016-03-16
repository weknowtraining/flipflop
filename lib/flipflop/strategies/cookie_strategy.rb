module Flipflop
  module Strategies
    class CookieStrategy < AbstractStrategy
      class << self
        def default_description
          "Stores features in a browser cookie. Applies to current user."
        end
      end

      def switchable?
        request?
      end

      def knows?(feature)
        return false unless request?
        request.cookie_jar.key?(cookie_name(feature))
      end

      def enabled?(feature)
        cookie = request.cookie_jar[cookie_name(feature)]
        cookie_value = cookie.is_a?(Hash) ? cookie["value"] : cookie
        cookie_value === "1"
      end

      def switch!(feature, enabled)
        request.cookie_jar[cookie_name(feature)] = {
          value: (enabled ? "1" : "0"),
          domain: :all,
        }
      end

      def clear!(feature)
        request.cookie_jar.delete(cookie_name(feature), domain: :all)
      end

      def cookie_name(feature)
        :"flipflop_#{feature}"
      end
    end
  end
end
