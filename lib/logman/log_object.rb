# frozen_string_literal: true

require 'date'
require 'fileutils'

module Logman
  class LogObject
    def initialize(config)
      @config = config
    end

    def generate
      template = valid_template
      filename = valid_filename
      title = valid_title

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
      filename = valid_filename
      editor = valid_editor
      
      if File.exist?(filename)
        system(editor, filename)
      else
        raise OperationError.new("Logfile does not exist.")
      end
    end

    def valid_template
      file = @config.log.path.template
      raise ValidationError.new("Please use a valid template path.") unless File.exist?(file)

      file
    end

    def valid_filename
      format = @config.log.format.filename
      filename = Date.today.strftime(format)
      raise ValidationError.new("Please use a valid format for filename.") unless filename.size > 0

      filename
    end

    def valid_title
      format = @config.log.format.title
      title = Date.today.strftime(format)
      raise ValidationError.new("Please use a valid format for title.") unless title.size > 0

      title
    end

    def valid_editor
      editor = @config.log.editor
      raise ValidationError.new("Please set an editor to open log file.") if editor.nil?

      editor
    end
  end
end
