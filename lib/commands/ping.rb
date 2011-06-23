class Ping < Flower::Command
  respond_to "ping"
  
  def self.respond(command, message, sender, flower)
    flower.say("Pong!", :mention => sender[:id])
  end

  def self.description
    "Pong!"
  end
end
