require "./cli"
require "./command"
require "./option"

module Easy_CLI
  VERSION = "0.1.0"
end

class PDU < Easy_CLI::CLI
  def initialize
    desc "pdu v2 alo"
  end
end

class Com < Easy_CLI::Command
  def initialize
    name("com")
    desc "do stuff"

    option "test", :string, "-t", "--test", desc: "allo"
  end

  def call(options)
    puts "COMCOMCOM => #{options["test"]}"
  end
end

class Com2 < Easy_CLI::Command
  def initialize
    name("com2")
    desc "do stuff2"

    option "test2", :boolean, "-t2", "--test2", desc: "allo"
  end

  def call(options)
    puts "COM2COM2COM2 => #{options["test2"]}"
  end
end

pdu = PDU.new

pdu.register(Com.new) do |com|
  com.register(Com2.new)
end
pdu.run(ARGV)
