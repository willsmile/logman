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

    def slack_webhook
      load.slack.webhook
    end

    def slack_channel
      load.slack.channel
    end
    
    def slack_username
      load.slack.username
    end

    def slack_icon
      load.slack.icon
    end

    def esa_team
      load.esa.team
    end

    def esa_token
      load.esa.token
    end
    
    def esa_postname_format
      load.esa.format.postname
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

    def validate_slack_webhook!
      raise ValidationError.new("Please setup the slack webhook in config.yml") if slack_webhook.nil?
    end

    def validate_slack_channel!
      raise ValidationError.new("Please setup the slack channel in config.yml") if slack_channel.nil?
    end

    def validate_slack_username!
      raise ValidationError.new("Please setup the slack username in config.yml") if slack_username.nil?
    end

    def validate_slack_icon!
      raise ValidationError.new("Please setup the slack icon in config.yml") if slack_icon.nil?
    end

    def validate_esa_team!
      raise ValidationError.new("Please setup the esa team in config.yml") if esa_team.nil?
    end

    def validate_esa_token!
      raise ValidationError.new("Please setup the esa token in config.yml") if esa_token.nil?
    end

    def validate_esa_postname_format!
      raise ValidationError.new("Please setup the esa postname format in config.yml") if esa_postname_format.nil?
    end
  end
end
