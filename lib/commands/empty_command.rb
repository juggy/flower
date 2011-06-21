class EmptyCommand < Flower::Command
  def self.parse(command, sender, flower)
    if command == ""
      flower.say("Yes, what? Try `help`.")
    end
  end
end
