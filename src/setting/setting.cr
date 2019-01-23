module Easy_CLI
  class Setting
    TYPES = [:boolean, :string, :integer, :array]

    getter full_name : String
    getter type : Symbol
    getter default : Nil | Int32 | String | Array(String)

    def initialize(@full_name, @type, @default)
        raise InvalidSettingType.new("'#{@type}' is not a valid type for an option.") if !TYPES.includes?(@type)
    end

    class InvalidSettingType < Exception
    end
  end
end