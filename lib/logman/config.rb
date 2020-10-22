# frozen_string_literal: true

require 'hashie'

module Logman
  class Config
    PROPERTY_FACTORY = %w[
                          log_path_template
                          log_format_filename
                          log_format_title
                          log_editor
                          slack_webhook
                          slack_channel
                          slack_username
                          slack_icon
                          esa_team
                          esa_token
                          esa_format_postname
                        ]

    def initialize(path)
      @path = path
    end

    def load!
      begin
        Hashie::Mash.load(@path)
      rescue ArgumentError
        raise ValidationError.new("Please use a valid config path.")
      end
    end

    PROPERTY_FACTORY.each do |property|
      define_method "#{property}" do
        val = eval("load!.#{dot_syntax_of(property)}")
        raise ValidationError.new("Please setup the #{speech_syntax_of(property)} in config file.") if val.nil?
        val
      end
    end

    def fetch_plugin_command!(plugin)
      validate_plugin(plugin)
      validate_command(plugin)

      load!.plugins[plugin].command
    end

    private

    def dot_syntax_of(name)
      elements = name.split('_')
      return name unless elements.size > 1
      elements.join('.')
    end

    def speech_syntax_of(name)
      elements = name.split('_')
      return name unless elements.size > 1
      elements.join(' ')
    end

    def validate_plugin(plugin_name)
      raise ValidationError.new("Please setup a valid plugin name.") unless load!.plugins.key?(plugin_name)
    end

    def validate_command(plugin_name)
      raise ValidationError.new("Please setup a valid plugin command.") if load!.plugins[plugin_name].command.empty?
    end
  end
end
