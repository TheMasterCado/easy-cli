require "spec"
require "../src/easy-cli"

class TestCLI < Easy_CLI::CLI
  def initialize
    name "test"
  end
end

class TestAdvancedCLI < Easy_CLI::CLI
  def initialize
    name "test"
    version "999"

    yes_option
    verb_option
    version_option
  end
end

class TestCommand < Easy_CLI::Command
  def initialize
    name "command"
    desc "Do absolutely nothing"
  end

  def call(data)
  end
end

class TestCommandSameOptionName < Easy_CLI::Command
  def initialize
    name "command"
    desc "Do absolutely nothing"

    option "opt", :boolean, "-o", "--opt"
    option "opt", :boolean, "-i", "--iopt"
  end

  def call(data)
  end
end

class TestLogger < Easy_CLI::Logger
  def initialize
    verbosity 5

    channel :err, :stderr, 3, true
    channel :out, :stdout, 5, false
    channel :out_file, :stdout, 5, true
  end
end
