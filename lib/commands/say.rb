class Say < Flower::Command
  respond_to "say"
  
  def self.respond(command, message, sender, flower)
    system "say", message
  end

  def self.description
    "Say it with words"
  end
end
