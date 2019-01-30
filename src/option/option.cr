module Easy_CLI
  class Option
    TYPES = [:boolean, :string, :integer, :array, :float]

    getter name : String
    getter type : Symbol
    getter short_flag : String
    getter long_flag : String
    getter default : Nil | Int32 | Float64 |String | Array(String)
    getter required : Bool
    getter desc : String

    def initialize(@name, @type, @short_flag, @long_flag, @default, @required, @desc)
      raise InvalidOptionType.new("'#{@type}' is not a valid type for an option.") if !TYPES.includes?(@type)
    end

    class InvalidOptionType < Exception
    end
  end
end
