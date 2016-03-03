class FlipFlop::InstallGenerator < Rails::Generators::Base

  def invoke_generators
    %w{ model migration routes }.each do |name|
      generate "flipflop:#{name}"
    end
  end

end
