require "../channel"

module Easy_CLI
  class Logger
    getter verbosity = 5
    getter channels = [
      Easy_CLI::Channel.new(:default_out, :stdout, 3, false),
      Easy_CLI::Channel.new(:default_err, :stderr, 1, false),
    ]
    getter file = "#{File.basename(PROGRAM_NAME)}.log"

    def initialize
    end

    def file(path)
      @file = path
    end

    def verbosity(v)
      @verbosity = v
    end

    def channel(name, output, verb, log_to_file)
      if self.has_channel?(name)
        raise ChannelNameNotUnique.new("A Channel named '#{name}' is already defined.")
      else
        @channels << Easy_CLI::Channel.new(name, output, verb, log_to_file)
      end
    end

    def has_channel?(chan)
      @channels.each do |ch|
        return true if ch.name == chan
      end
    end

    def get_channel(chan)
      @channels.each do |ch|
        return ch if ch.name == chan
      end
      return @channels.first
    end

    def p(chan, message)
      puts(chan, message)
    end

    def puts(chan, message)
      if !self.has_channel?(chan)
        raise ChannelNotDefined.new("Channel '#{chan}' is not defined for this Logger.")
      else
        ch = self.get_channel(chan)
        ch.puts(message) if @verbosity >= ch.verbosity
        File.write(@file, "#{message}\n", mode: "a") if ch.log_to_file
      end
    end

    class ChannelNotDefined < Exception
    end
    class ChannelNameNotUnique < Exception
    end
  end
end
