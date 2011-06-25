# encoding: utf-8
class Stats < Flower::Command
  respond_to "stats"
  CHARTBEAT_URL = "http://api.chartbeat.com"
  
  def self.respond(command, message, sender, flower)
    case message
    when "online"
      flower.say("Online right now: #{online_right_now}", :mention => sender[:id])
    end
  end

  def self.description
    "stats: 'online' - Online right now"
  end

  # stats
  def self.online_right_now
    require 'open-uri'
    doc = open "#{CHARTBEAT_URL}/quickstats?host=#{Flower::Config.chartbeat['domain']}&apikey=#{Flower::Config.chartbeat['key']}"
    json = JSON.parse doc.read
    json["people"]
  end
end
