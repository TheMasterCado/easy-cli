require "../channel"

module Easy_CLI
    class Logger

        getter verbosity = 3
        getter channels = [
            Easy_CLI::Channel.new(:default_out, :stdout, 3, false),
            Easy_CLI::Channel.new(:default_err, :stderr, 1, false)
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
            if self.has_channel?(channel)
                raise ChannelNameNotUnique.new("A Channel named '#{channel}' is already defined.") 
            else
                @channels << Easy_CLI::Channel.new(name, output, verb, log_to_file)
            end
        end

        def has_channel?(channel)
            @channels.each do |ch|
                return true if ch.name == channel
            end
        end

        def get_channel(channel)
            @channels.each do |ch|
                return ch if ch.name == channel
            end
            return @channels.first
        end

        def p(channel, message)
            puts(channel, message)
        end

        def puts(channel, message)
            if !self.has_channel?(channel)
                raise ChannelNotDefined.new("Channel '#{channel}' is not defined for this Logger.") 
            else
                ch = self.get_channel(channel)
                ch.puts(message) if @verbosity >= ch.verbosity
                File.write(@file, "#{message}\n", mode: "a") if ch.log_to_file
            end
        end

        class ChannelNotDefined < Exception
        end
    end
end