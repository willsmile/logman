# frozen_string_literal: true

require 'fileutils'
require 'slack-notifier'
require 'esa'

module Logman
  class Post
    def initialize(config)
      @config = config
    end

    def esa(log_object)
      filename = log_object.valid_filename
      postname = Date.today.strftime(@config.esa.format.postname)

      message = "\n post by Logman v#{Logman::VERSION}"
      body_md = log_body(filename) << message

      response = esa_client.create_post(name: postname, body_md: body_md)

      id = response.body["number"] unless response.body.nil?
      if response.status == 201 && Integer === id
        if esa_client.update_post(id, wip: false)
          puts "Post logfile #{filename} to esa successful."
        else
          puts "Post logfile #{filename} to esa unsuccessful."
        end
      else
        STDERR.puts 'Cannot connect to esa.'
      end
    end

    def slack(log_object)
      filename = log_object.valid_filename

      message = "\n post by Logman v#{Logman::VERSION}"
      body_md = log_body(filename) << message
      body_md.insert(0, '```')
      body_md.insert(-1, '```')

      if slack_notifier.post text: body_md, icon_emoji: @config.slack.icon
        puts "Post logfile #{filename} to slack successful."
      else
        puts "Post logfile #{filename} to slack unsuccessful."
      end
    end

    def esa_client
      Esa::Client.new(access_token: @config.esa.token, current_team: @config.esa.team)
    end

    def slack_notifier
      Slack::Notifier.new @config.slack.webhook, channel: @config.slack.channel,
                                                 username: @config.slack.username
    end

    def log_body(filename)
      unless File.exist?(filename)
        raise Errno::ENOENT, "Logfile #{filename} does not exist."
      end

      file = File.open(filename, 'r+')
      lines = file.readlines
      file.close

      body = String.new(encoding: "UTF-8")
      lines.each do |line|
        body << line
      end

      body
    end
  end
end
