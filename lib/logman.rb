# frozen_string_literal: true

require 'hashie'
require 'logman/log_object'
require 'logman/logfiles'
require 'logman/post'
require 'logman/version'

module Logman
  LOGMANPATH = ENV.fetch("LOGMANPATH")
  CONFIG_FILENAME = 'config.yml'

  def self.config
    config_file_path = LOGMANPATH + '/' + CONFIG_FILENAME
    Hashie::Mash.load(config_file_path)
  end
end
