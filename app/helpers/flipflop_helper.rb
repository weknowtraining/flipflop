# Access to feature-flipflopping configuration.
module FlipFlopHelper

  # Whether the given feature is switched on
  def feature?(key)
    FlipFlop.on? key
  end

end
