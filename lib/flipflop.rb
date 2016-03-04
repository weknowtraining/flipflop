require "active_support/concern"
require "active_support/inflector"
require "active_support/core_ext/hash/reverse_merge"
require "active_support/core_ext/object/blank"
require "active_support/core_ext/object/try"

require "flipflop/controller_filters"
require "flipflop/declarable"
require "flipflop/feature_set"
require "flipflop/feature_definition"
require "flipflop/facade"

require "flipflop/strategies/abstract_strategy"
require "flipflop/strategies/active_record_strategy"
require "flipflop/strategies/cookie_strategy"
require "flipflop/strategies/default_strategy"
require "flipflop/strategies/test_strategy"

require "flipflop/engine" if defined?(Rails)

module Flipflop
  extend Facade
  include Strategies
end
