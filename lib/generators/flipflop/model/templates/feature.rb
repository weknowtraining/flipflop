class Feature < ActiveRecord::Base
  extend FlipFlop::Declarable

  strategy FlipFlop::CookieStrategy
  strategy FlipFlop::DatabaseStrategy
  strategy FlipFlop::DeclarationStrategy
  default false

  # Declare your features here, e.g:
  #
  # feature :world_domination,
  #   default: true,
  #   description: "Take over the world."

end
