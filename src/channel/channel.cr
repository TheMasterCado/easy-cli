module Easy_CLI
    class Channel
        TYPES = [:stdout, :stderr]

        getter output = :stdout
        getter verbosity : Int32
        getter name : Symbol
        getter log_to_file : Bool

        def initialize(@name, @output, @verbosity, @log_to_file)
            raise InvalidChannelOutput.new("'#{@output}' is not a valid output for a channel.") if !TYPES.includes?(@output)
        end

        def p(message)
            puts(message)
        end

        def puts(message)
            case @output
            when :stdout
                STDOUT.puts(message)
            when :stderr
                STDERR.puts(message)
            end
        end

        class InvalidChannelOutput < Exception
        end
    end
end
