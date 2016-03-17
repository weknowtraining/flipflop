module Flipflop
  module Strategies
    class QueryStringStrategy < AbstractStrategy
      class << self
        def default_description
          "Interprets query string parameters as features."
        end
      end

      def enabled?(feature)
        return unless request?
        return unless request.params.has_key?(feature)
        request.params[feature].to_s != "0"
      end
    end
  end
end
