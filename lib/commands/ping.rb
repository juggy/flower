class Ping < Flower::Command
  respond_to "ping"
  
  def self.respond(command, sender, flower)
    flower.say("Pong!", :mention => sender[:id])
  end

  def self.description
    "Pong!"
  end
end
