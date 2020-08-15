# frozen_string_literal: true

require 'hashie'

module Logman
  class Config
    def initialize(path)
      @path = path
    end

    def load
      begin
        Hashie::Mash.load(@path)
      rescue ArgumentError
        raise OperationError.new("Please use a valid config path.")
      end
    end
  end
end
