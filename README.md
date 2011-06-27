# Flower

### Flower is a Flowdock Bot

Flowdock is a team collaboration and group chat service, similar to Campfire.

Flowdock is also the group chat service of choice at the Mynewsdesk R&D dept. To make it more fun and/or usable, we made this bot.

Flower was made to be easy to extend with your own commands.

### How do I use it?

1. Create a new Flowdock account for your Flower bot. Give it a nick, for example "Bot", or "Steve".
2. Download the source
3. Copy and rename `config.yml.example` to `config.yml`, and fill it with your settings
4. `rake run`
5. Mention your Bot in the chat to command it

### Writing my own commands

You should write your own commands to make Flower fun and/or useful for your team.

This is easy. Simply create a class like this in lib/commands that inherits Flower::Command:

    class MyCommand < Flower::Command
      respond_to "testing"
      def self.respond(command, message, sender, flower)
        # Do something with "flower"
        flower.say("Only testing")
      end
      def self.description
        "Text that describes your command. It's used in the built-in Help command."
      end
    end

`MyCommand.repsond` will be invoked when a message prefix matches what you `respond_to`. Arguments passed are:

* command - The matched command
* message - The entire message
* sender - A hash with sender user id/nick info: `{:id => 123, :nick => "Jonas"}`
* flower - The Flower instance, that can `say` or `paste` something