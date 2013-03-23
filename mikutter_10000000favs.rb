# -*- conding: utf-8- -*-
require 'yaml'
require 'twitter'

Plugin.create :mikutter_1favs do
  config = YAML.load_file(File.expand_path('../config.yaml', __FILE__)).symbolize
  client = Twitter::Client.new(config)

  command(
    :mikutter_1favs,
    name: "Do 10000000favs",
    condition: Plugin::Command[:CanReTweetAll],
    visible: true,
    role: :timeline
  ) do |opt|
    m = opt.messages.first

    Thread.new do
      client.retweet(m.id) if m.respond_to?(:id)
      Plugin.call(:update, nil, [Message.new(message: "Retweeted:\n#{m.message}", system: true)])
    end
  end
end
