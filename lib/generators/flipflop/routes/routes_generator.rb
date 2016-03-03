class FlipFlop::RoutesGenerator < Rails::Generators::Base

  def add_route
    route %{mount FlipFlop::Engine => "/flipflop"}
  end

end
