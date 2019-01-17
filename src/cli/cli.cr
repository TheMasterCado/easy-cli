require "../command"
require "../option"
require "../parser"

module Easy_CLI
  abstract class CLI < Command

    getter call_name = File.basename(PROGRAM_NAME)

    abstract def initialize

    def call(options)
      raise Exception.new("No root command defined.")
    end

    def run(args)
      p args.class
      command = Parser.parse_command(args, self)
      if command.is_a?(CLI) || !command.commands.empty?
        STDERR.puts command.usage
        exit(1)
      else
        options = Parser.parse_options(args, command)
        command.call(options)
      end
    end
  end
end