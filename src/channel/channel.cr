module Easy_CLI
    class Channel
        TYPES = [:stdout, :stderr]

        getter output = :stdout
        getter verbosity : Int32
        getter name : Symbol
        getter log_to_file: Boolean

        def initialize(@name, @output, @verbosity, @log_to_file)
            raise InvalidChannelOutput.new("'#{@output}' is not a valid output for a channel.") if !TYPES.includes?(@type)
        end

        class InvalidChannelOutput < Exception
        end
    end
end
