# frozen_string_literal: true

module Logman
  class PluginManager
    def initialize(config)
      @config = config
    end

    def execute(plugin)
      command = @config.fetch_plugin_command!(plugin)
      system("#{command}", exception: true)
    end
  end
end
