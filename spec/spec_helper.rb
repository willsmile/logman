require "bundler/setup"
require "logman"

RSPEC_ROOT = File.dirname __FILE__
CONFIG_FIXTURES_PATH = "#{RSPEC_ROOT}/fixtures/config"
TEMPLATE_FIXTURES_PATH = "#{RSPEC_ROOT}/fixtures/template"

RSpec.configure do |config|
  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
