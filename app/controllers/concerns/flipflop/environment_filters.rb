module Flipflop::EnvironmentFilters
  def require_development
    head :forbidden unless Rails.env.development? or Rails.env.test?
  end
end
