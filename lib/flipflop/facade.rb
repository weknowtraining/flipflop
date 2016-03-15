module Flipflop
  module Facade
    def config
      Class.new do
        extend Declarable
        class_eval(&Proc.new)
      end
    end

    def enabled?(feature)
      FeatureSet.instance.enabled?(feature)
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
        FeatureSet.instance.enabled?(method[0..-2].to_sym)
      else
        super
      end
    end
  end
end
