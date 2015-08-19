module Sagashi
  class Engine < ::Rails::Engine
    isolate_namespace Sagashi

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
