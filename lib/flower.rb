require "rubygems"
require "bundler/setup"
require 'typhoeus'
require 'json'

class Flower
  require File.expand_path(File.join(File.dirname(__FILE__), 'session'))
  require File.expand_path(File.join(File.dirname(__FILE__), 'command'))
  require File.expand_path(File.join(File.dirname(__FILE__), 'config'))

  COMMANDS = {} # We are going to load available commands in here

  Dir.glob("lib/commands/*.rb").each do |file|
    require File.expand_path(File.join(File.dirname(__FILE__), "..", file))
  end

  attr_accessor :messages_url, :post_url, :flow_url, :session, :uuid, :users

  def initialize
    self.messages_url = base_url + "/flows/#{Flower::Config.flow}/apps/chat/messages"
    self.post_url     = base_url + "/messages"
    self.flow_url     = base_url + "/flows/#{Flower::Config.flow}.json"
    self.uuid         = Flower::Config.uuid
    self.session      = Session.new()
    self.users        = {}
  end

  def say(message, options = {})
    post(message, parse_tags(options))
  end

  def paste(message, options = {})
    message = message.join("\n") if message.respond_to?(:join)
    message = message.split("\n").map{ |str| (" " * 4) + str }.join("\\n")
    post(message, parse_tags(options))
  end

  def boot!
    session.login
    get_users!
    monitor!
  end

  private
  def base_url
    "https://#{Flower::Config.company.downcase}.flowdock.com"
  end

  def monitor!
    get_messages do |messages|
      respond_to(messages)
    end
  end

  def get_users!
    data = session.get_json(flow_url)
    data["users"].map{|u| u["user"] }.each do |user|
      self.users[user["id"]] = {:id => user["id"], :nick => user["nick"]}
    end
  end

  def get_messages
    since = nil
    while(true) do
      messages = session.get_json(messages_url, :after_time => since, :count => (since ? 5 : 1))
      if !messages.empty?
        yield messages
        since = messages.last["sent"]
      end
      sleep(5)
    end
  end
  
  def respond_to(messages)
    messages.each do |message_json|
      next if message_json["uuid"] == uuid # Ignore my own messages
      
      if match = bot_message(message_json["content"])
        match = match.to_a[1].split
        Flower::Command.delegate_command(match.shift || "", match.join(" "), users[message_json["user"].to_i], self)
      end
    end
  end

  def bot_message(content)
    content.respond_to?(:match) && content.match(/^#{Flower::Config.bot_nick}[\s|,|:]*(.*)/i)
  end

  def post(message, tags = nil)
    session.post(post_url, :uuid => uuid, :message => "\"#{message}\"", :tags => tags, :app => "chat", :event => "message", :channel => "/flows/main")
  end

  def parse_tags(options)
    if options[:mention]
      ":highlight:#{options[:mention]}"
    end
  end
end
