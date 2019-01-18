require "./cli"
require "./command"
require "./option"
require "./config"

module Easy_CLI
  VERSION = "0.1.0"
end

class MyConfig < Easy_CLI::Config
  def initialize
    #@values["test"] = "ok"
  end
end

MyConfig.new

class PDU < Easy_CLI::CLI
  def initialize
    name "pdu"

    option "yes", :boolean, "-y", "--yes", desc: "always yes"
  end
end

class Com < Easy_CLI::Command
  def initialize
    name("com")
    desc "do stuff"

    option "test", :string, "-t", "--test", desc: "allo"
  end

  def call(args)
    puts "COMCOMCOM => #{args["test"]}"
  end
end

class Com2 < Easy_CLI::Command
  def initialize
    name("com2")
    desc "do stuff2"

    argument "patente"
  end

  def call(args)
    puts "COM2COM2COM2 => #{args["patente"]}"
  end
end

pdu = PDU.new

pdu.register(Com.new) do |com|
  com.register(Com2.new)
end

pdu.run(ARGV)
