class Flower::Command
  def self.respond_to(*commands)
    commands.each do |command|
      if Flower::COMMANDS[command]
        warn "Command already defined: #{command}"
      else
        Flower::COMMANDS[command] = self
      end
    end
  end

  def self.delegate_command(command, message, sender, flower)
    return if Flower::COMMANDS[command].nil?
    Flower::COMMANDS[command].respond(command, message, sender, flower)
  end
end
