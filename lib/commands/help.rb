class Help < Flower::Command
  def self.parse(command, sender, flower)
    if command =~ /^help/i
      flower.say("Available commands:")
      text = [
        "ping - Pong!",
        "help - This message"
      ]
      flower.paste(text)
    end
  end
end