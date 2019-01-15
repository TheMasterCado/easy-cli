module Easy_CLI
  class CLI
    abstract class Command
      class Option
        getter name : String
        getter type : Symbol
        getter short_flag : String
        getter long_flag : String
        getter default : Nil | Int32 | String | Array(String)
        getter required : Bool
        getter desc : String

        def initialize(@name, @type, @short_flag, @long_flag, @default, @required, @desc)
        end

        class InvalidOptionType < Exception
        end
      end
    end
  end
end
