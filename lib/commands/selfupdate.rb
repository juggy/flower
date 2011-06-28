class Selfupdate < Flower::Command
  respond_to "selfupdate"
  def self.respond(command, message, sender, flower)
    diff = `git log --decorate --left-right --graph --cherry-pick --oneline master...origin/master`
    if diff.empty?
      flower.say("No updates found. No need to reboot!")
    else
      flower.say("Applying updates and rebooting:")
      flower.paste(diff)
      system("git pull --rebase")
      exec("rake run &")
    end
  end
  
  def self.description
    "Do a 'git pull' and restart Flower"
  end
end
