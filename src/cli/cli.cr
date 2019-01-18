require "../command"
require "../option"
require "../parser"

module Easy_CLI
  abstract class CLI < Command
    getter call_name = File.basename(PROGRAM_NAME)

    abstract def initialize

    def call(args)
      raise Exception.new("You can't invoke 'call' on a CLI, invoke 'run'.")
    end

    def run(args)
      command = Parser.parse_command(args, self)
      if command.is_a?(CLI) || !command.commands.empty?
        puts command.usage
        exit(1)
      end
      options = Parser.parse_options(args, command)
      command.call(options)
    end
  end
end
