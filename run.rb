$: << "."
require "lib/flower"
require "lib/session"
require "lib/command"

Dir.glob("lib/commands/*.rb").each do |file|
  require file
end

Flower.new
