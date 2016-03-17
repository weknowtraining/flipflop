module Flipflop
  module Strategies
    class SessionStrategy < AbstractStrategy
      class << self
        def default_description
          "Stores features in the user session. Applies to current user."
        end
      end

      def switchable?
        request?
      end

      def enabled?(feature)
        return unless request?
        return unless request.session.has_key?(feature)
        request.session[feature]
      end

      def switch!(feature, enabled)
        request.session[feature] = enabled
      end

      def clear!(feature)
        request.session.delete(feature)
      end
    end
  end
end
