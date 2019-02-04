require "spec"
require "../src/easy-cli"

class TestCLI < Easy_CLI::CLI
    def initialize
        name "test"
    end
end

class TestCommand <Easy_CLI::Command
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