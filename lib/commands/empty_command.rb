class EmptyCommand < Flower::Command
  def self.parse(command, sender, flower)
    if command == ""
      flower.say("#{sender[:nick]}, yes, what? Try `help`.", :mention => sender[:id])
    end
  end
end
