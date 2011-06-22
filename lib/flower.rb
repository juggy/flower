require "rubygems"
require "bundler/setup"
require 'typhoeus'
require 'json'

class Flower
  attr_accessor :messages_url, :post_url, :flow_url, :session, :uuid, :users
  
  def initialize
    puts " Booting Flower..."

    self.messages_url = "https://mynewsdesk.flowdock.com/flows/main/apps/chat/messages"
    self.post_url     = "https://mynewsdesk.flowdock.com/messages"
    self.flow_url     = "https://mynewsdesk.flowdock.com/flows/main.json"
    self.uuid         = "vpyx304DPTA0msh-"
    self.session      = Session.new
    self.users        = {}
    
    session.login
    get_users!
    monitor!
  end

  def say(message, options = {})
    if options[:mention]
      tags = ":highlight:#{options[:mention]}"
    end
    post(message, tags)
  end

  def paste(message)
    message = message.join("\n") if message.respond_to?(:join)
    message = message.split("\n").map{ |str| (" " * 4) + str }.join("\\n")
    post(message)
  end

  private
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
        Flower::Command.delegate_command(match.to_a[1], users[message_json["user"].to_i], self)
      end
    end
  end

  def bot_message(content)
    content.respond_to?(:match) && content.match(/^Bot[\s|,|:]*(.*)/)
  end

  def post(message, tags = nil)
    session.post(post_url, :uuid => uuid, :message => "\"#{message}\"", :tags => tags, :app => "chat", :event => "message", :channel => "/flows/main")
  end
end
