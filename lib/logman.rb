# frozen_string_literal: true

require 'logman/config'
require 'logman/log_object'
require 'logman/post'
require 'logman/version'
require 'plugins/logfiles'

module Logman
  class OperationError < StandardError; end
end
