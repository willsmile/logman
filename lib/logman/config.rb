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
        raise ValidationError.new("Please use a valid config path.")
      end
    end

    def template_path
      load.log.path.template
    end

    def filename_format
      load.log.format.filename
    end

    def title_format
      load.log.format.title
    end

    def editor
      load.log.editor
    end

    def validate_template_path!
      raise ValidationError.new("Please setup the template path in config.yml") if template_path.nil?
    end

    def validate_filename_format!
      raise ValidationError.new("Please setup the filename format in config.yml") if filename_format.nil?
    end

    def validate_title_format!
      raise ValidationError.new("Please setup the title format in config.yml") if title_format.nil?
    end

    def validate_editor!
      raise ValidationError.new("Please setup the editor in config.yml") if editor.nil?
    end
  end
end
