task :run do
  $: << "."
  require "lib/flower"
  require "lib/session"
  require "lib/command"
  require "lib/config"

  Dir.glob("lib/commands/*.rb").each do |file|
    require file
  end

  Flower.new
end