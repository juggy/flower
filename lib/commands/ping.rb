class Ping < Flower::Command
  def self.parse(command, sender, flower)
    if command =~ /^ping/i
      flower.say("Pong!")
    end
  end
end