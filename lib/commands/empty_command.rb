class EmptyCommand < Flower::Command
  def self.parse(command, flower)
    if command == ""
      flower.say("Yes, what? Try `help`.")
    end
  end
end
