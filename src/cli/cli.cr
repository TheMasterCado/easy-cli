require "../command"
require "../parser"
require "../logger"

module Easy_CLI
  abstract class CLI < Command
    getter call_name = File.basename(PROGRAM_NAME)
    getter logger = Logger.new
    getter version = "Not available"

    @std_options = {
      :yes     => false,
      :verb    => false,
      :version => false,
    }

    abstract def initialize

    def call(data)
      raise Exception.new("You can't invoke 'call' on a CLI, invoke 'run'.")
    end

    def logger(l)
      @logger = l
    end

    def version(v)
      @version = v
    end

    def yes_option
      @std_options[:yes] = true
    end

    def verb_option
      @std_options[:verb] = true
    end

    def version_option
      @std_options[:version] = true
    end

    def cli
      self
    end

    def run(args)
      command = Parser.parse_command(args, self)
      options = Parser.parse_options(args, command, @std_options)
      if command.is_a?(CLI) || !command.commands.empty?
        puts command.usage
        exit(1)
      end
      Parser.ask_for_required_options(command, options)
      @logger.verbosity(options["verb"]) if options["verb"]
      command.call(options)
    end
  end
end
