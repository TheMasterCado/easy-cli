require "./cli"
require "./command"
require "./option"
require "./logger"

module Easy_CLI
  VERSION = "0.1.0"
end

class PDU < Easy_CLI::CLI
  def initialize
    name "mycli"

  end
end

class Com < Easy_CLI::Command
  def initialize
    name "com"
    desc "My first command with Easy CLI"

    argument "name"
    option "night", :boolean, nil, "--night", "Say good night instead of good morning"
  end

  def call(data)
    if data["night"]
      puts "Good night #{data["name"]}"
    else
      puts "Good morning #{data["name"]}"
    end
  end
end

pdu = PDU.new

pdu.register(Com.new)

pdu.run(ARGV)
