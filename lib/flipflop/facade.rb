module Flipflop
  module Facade
    def config
      Module.new do
        extend Declarable
        instance_eval(&Proc.new)
      end
    end

    def enabled?(feature)
      FeatureSet.current.enabled?(feature)
    end
    alias_method :on?, :enabled?

    def reset!
      FeatureSet.reset!
    end

    private

    def respond_to_missing?(method, include_private = false)
      method[-1] == "?"
    end

    def method_missing(method, *args)
      if method[-1] == "?"
        FeatureSet.current.enabled?(method[0..-2].to_sym)
      else
        super
      end
    end
  end
end
