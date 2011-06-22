# encoding: utf-8

class Help < Flower::Command
  respond_to "help", "hjälp"

  def self.respond(command, sender, flower)
    flower.say("Available commands:")
    text = [
      "ping - Pong!",
      "help - This message"
    ]
    flower.paste(text)
  end
end
