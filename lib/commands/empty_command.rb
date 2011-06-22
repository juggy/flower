class EmptyCommand < Flower::Command
  respond_to ""
  
  def self.respond(command, sender, flower)
    flower.say("#{sender[:nick]}, yes, what? Try `help`.", :mention => sender[:id])
  end
end
