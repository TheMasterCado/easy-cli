module Easy_CLI
  class Setting
    TYPES = [:boolean, :string, :integer, :array]

    getter name : String
    getter type : Symbol
    getter default : Nil | Int32 | String | Array(String)
    getter required : Bool

    def initialize(@name, @type, @default, @required)
        raise InvalidSettingType.new("'#{@type}' is not a valid type for an option.") if !TYPES.includes?(@type)
    end

    class InvalidSettingType < Exception
    end
  end
end