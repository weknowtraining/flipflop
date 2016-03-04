module Flipflop
  module Strategies
    class CookieStrategy < AbstractStrategy
      class << self
        def default_description
          "Stores features in a browser cookie. Applies to current user."
        end

        attr_accessor :cookies
      end

      def switchable?
        true
      end

      def knows?(feature)
        cookies.key?(cookie_name(feature))
      end

      def enabled?(feature)
        cookie = cookies[cookie_name(feature)]
        cookie_value = cookie.is_a?(Hash) ? cookie["value"] : cookie
        cookie_value === "1"
      end

      def switch!(feature, enabled)
        cookies[cookie_name(feature)] = {
          value: (enabled ? "1" : "0"),
          domain: :all,
        }
      end

      def clear!(feature)
        cookies.delete(cookie_name(feature), domain: :all)
      end

      def cookie_name(feature)
        :"flipflop_#{feature}"
      end

      private

      def cookies
        self.class.cookies || {}
      end

      module Loader
        extend ActiveSupport::Concern

        included do
          before_filter do
            CookieStrategy.cookies = cookies
          end
          
          after_filter do
            CookieStrategy.cookies = nil
          end
        end
      end
    end
  end
end
