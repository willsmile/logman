# frozen_string_literal: true

require 'logman/config'
require 'logman/log_object'
require 'logman/logfiles'
require 'logman/post'
require 'logman/version'

module Logman
  def self.config
    Logman::Config.load
  end
end
