class Flower::Config
  CONFIG = YAML.load File.read("config.yml")
  
  def self.method_missing(sym, *args, &block)
    CONFIG[sym.to_s]
  end
end