# frozen_string_literal: true

require 'logman/config'
require 'logman/log_object'
require 'logman/post'
require 'logman/version'
require 'logman/plugin_manager'

module Logman
  class OperationError < StandardError; end
  class ValidationError < StandardError; end
end
