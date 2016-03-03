module FlipFlop
  class Engine < ::Rails::Engine
    isolate_namespace FlipFlop

    initializer "flipflop.blarg" do
      ActionController::Base.send(:include, FlipFlop::CookieStrategy::Loader)
    end
  end
end
