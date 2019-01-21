module Easy_CLI
    abstract class Logger

        @verbosity = 3
        @channels = [] of Channel
        @file: String = "#{File.basename(PROGRAM_NAME)}.log"

        abstract def initialize
        
        def file(path)
            @file = path
        end

        def verbosity(v)
            @verbosity = v
        end

        def channel(name, output, verb, log_to_file)
            @channels << Channel.new(name, output, verb, log_to_file)
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
        end

        def p(channel, message)
            if self.has_channel?(channel)
                raise new ChannelNotDefined("Channel '#{channel}' is not defined for this Logger.") 
            else
                ch = self.get_channel(channel)
                ch.write(message) if @verbosity >= ch.verbosity
                File.write(@file, message, mode: "a") if ch.log_to_file
            end
        end

        class ChannelNotDefined < Exception
        end
    end
end