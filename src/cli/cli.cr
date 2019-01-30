require "../command"
require "../parser"
require "../logger"

module Easy_CLI
  abstract class CLI < Command

    getter call_name = File.basename(PROGRAM_NAME)
    getter logger = Logger.new

    @show_yes_opt = true
    @show_verb_opt = true

    abstract def initialize

    def call(args)
      raise Exception.new("You can't invoke 'call' on a CLI, invoke 'run'.")
    end

    def logger(l)
      @logger = l
    end

    def no_yes_opt
      @show_yes_opt = false
    end

    def no_verb_opt
      @show_verb_opt = false
    end

    def run(args)
      command = Parser.parse_command(args, self)
      if command.is_a?(CLI) || !command.commands.empty?
        puts command.usage
        exit(1)
      end
      options = Parser.parse_options(args, command, @show_yes_opt, @show_verb_opt)
      command.call(options)
    end

  end
end
