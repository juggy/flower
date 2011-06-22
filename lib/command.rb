class Flower::Command
  def self.respond_to(*commands)
    commands.each do |command|
      Flower::COMMANDS[command] ? Flower::COMMANDS[command] << self : Flower::COMMANDS[command] = [self]
    end
  end

  def self.delegate_command(command, sender, flower)
    Flower::COMMANDS[command].each do |klass|
      klass.respond(command, sender, flower)
    end
  end
end
