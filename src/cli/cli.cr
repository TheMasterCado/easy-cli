require "../command"
require "../option"
require "../parser"

module Easy_CLI
  abstract class CLI
    @registry : Registry

    def initialize
      @registry = Registry.new
    end

    def register(command, &block)
      @registry.register(command) do |com|
        yield com
      end
    end

    def register(command)
      @registry.register(command)
    end

    def call(args)
      command = Parser.parse_command(args, @registry)
      if command.is_a?(Registry)
        STDERR.puts @registry.usage
        exit(1)
      end
      options = Parser.parse_options(args, command)
      command.call(options)
    end

    macro program_name(n)
      @registry.call_name = {{n}}
    end

    macro program_desc(d)
      @registry.description = {{d}}
    end

    private class Registry < Command

      property call_name = File.basename(PROGRAM_NAME)
      property description = ""

      def call(options)
        raise CommandException.new("Registry called directly.")
      end
    end
  end
end
