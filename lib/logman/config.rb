# frozen_string_literal: true

require 'hashie'

module Logman
  module Config
    LOGMANPATH = ENV.fetch("LOGMANPATH")
    CONFIG_FILENAME = 'config.yml'

    def self.load(config_path = default_config_path)
      begin
        Hashie::Mash.load(config_path)
      rescue ArgumentError
        STDERR.puts 'Please use a valid config path.'
      end
    end

    def self.default_config_path
      LOGMANPATH + '/' + CONFIG_FILENAME
    end
  end
end
