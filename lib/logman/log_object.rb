# frozen_string_literal: true

require 'date'
require 'fileutils'

module Logman
  class LogObject
    def initialize(config)
      @config = config
    end

    def generate
      @config.validate_template_path!
      @config.validate_title_format!

      template = @config.template_path
      title = parser(@config.title_format)

      temp_file = File.open(template, 'r+')
      lines = temp_file.readlines
      temp_file.close
      lines = [title + "\n"] + lines

      if File.exist?(filename)
        raise OperationError.new("Logfile exists.")
      else
        log_file = File.new(filename, 'w')
        lines.each { |line| log_file.write line }
        log_file.close
        puts('Logfile generation successed.')
      end
    end

    def open
      @config.validate_editor!
      editor = @config.editor

      if File.exist?(filename)
        system(editor, filename)
      else
        raise OperationError.new("Logfile does not exist.")
      end
    end

    def filename
      @config.validate_filename_format!
      parser(@config.filename_format)
    end

    def parser(format)
      Date.today.strftime(format)
    end
  end
end
