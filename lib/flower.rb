require 'rubygems'
require 'typhoeus'
require 'json'

class Flower
  attr_accessor :messages_url, :post_url, :session, :uuid
  
  def initialize
    self.messages_url = "https://mynewsdesk.flowdock.com/flows/main/apps/chat/messages"
    self.post_url     = "https://mynewsdesk.flowdock.com/messages"
    self.uuid         = "vpyx304DPTA0msh-"
    self.session      = Session.new
    
    monitor!
  end
  
  def say(message)
    session.post(post_url, :uuid => uuid, :message => "\"#{message}\"", :app => "chat", :event => "message", :channel => "/flows/main")
  end
  
  def monitor!
    session.login
    puts(" Im now online")
    #say("Bot is online!")
    get_messages do |messages|
      respond_to(messages)
    end
  end
  
  private
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
      
      if match = message_json["content"].match(/^Bot[\s|,|:]*(.*)/)
        matches = match.to_a
        puts(" Got message: #{matches[1]}")
        case matches[1]
        when ""
          say("Yes, what?")
        when /ping/i
          say("Pong!")
        end
      end
    end
  end
end