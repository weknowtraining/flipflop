class Feature < ActiveRecord::Base
  extend Flipflop::Declarable

  strategy Flipflop::CookieStrategy
  strategy Flipflop::ActiveRecordStrategy
  strategy Flipflop::DefaultStrategy

  # Declare your features here, e.g:
  #
  # feature :world_domination,
  #   default: true,
  #   description: "Take over the world."
end
