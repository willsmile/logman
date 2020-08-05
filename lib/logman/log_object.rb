# frozen_string_literal: true

require 'date'
require 'fileutils'

module Logman
  class LogObject
    def initialize(template_path = nil, filename_format = nil, title_format = nil)
      @template_path = template_path
      @filename_format = filename_format
      @title_format = title_format
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
        puts('Log file exists.')
      else
        log_file = File.new(filename, 'w')
        lines.each { |line| log_file.write line }
        log_file.close
        puts('Log file generation successed.')
      end
    end

    def open
      filename = valid_filename
      editor = valid_editor
      
      if File.exist?(filename)
        system(editor, filename)
      else
        puts('Log file does not exist.')
      end
    end

    def valid_template
      file = if @template_path.nil?
                Logman.config.log.path.template
              else
                @template_path
              end
      STDERR.puts 'Please use a valid template path.' unless File.exist?(file)

      file
    end

    def valid_filename
      format = if @filename_format.nil?
                  Logman.config.log.format.filename
                else
                  @filename_format
                end
      filename = Date.today.strftime(format)
      STDERR.puts 'Please use a valid format for filename.' unless filename.size > 0

      filename
    end

    def valid_title
      format = if @title_format.nil?
                  Logman.config.log.format.title
                else
                  @title_format
                end
      title = Date.today.strftime(format)
      STDERR.puts 'Please use a valid format for title.' unless title.size > 0

      title
    end

    def valid_editor
      editor = Logman.config.log.editor
      STDERR.puts 'Please set an editor to open log file.' if editor.nil?

      editor
    end
  end
end
