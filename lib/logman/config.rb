# frozen_string_literal: true

require 'hashie'

module Logman
  class Config
    LOGMANPATH = ENV.fetch("LOGMANPATH")
    CONFIG_FILENAME = 'config.yml'

    def initialize(path: nil)
      @path = path || LOGMANPATH + '/' + CONFIG_FILENAME
    end

    def load
      begin
        Hashie::Mash.load(@path)
      rescue ArgumentError
        STDERR.puts 'Please use a valid config path.'
      end
    end
  end
end
