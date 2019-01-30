module Easy_CLI
  class Setting
    TYPES = [:boolean, :string, :integer, :array, :float]

    TRUE_VALUES = ["1", "t", "T", "true", "TRUE", "on", "ON", "enabled", "ENABLED"]


    getter full_name : String
    getter type : Symbol
    getter default : Nil | Int32 | Float64 | String | Array(String)

    def initialize(@full_name, @type, @default)
        raise InvalidSettingType.new("'#{@type}' is not a valid type for an option.") if !TYPES.includes?(@type)
    end

    def find_in(config : YAML::Any | Nil)
      if c = config
        name_parts = @full_name.split(".")
        cur = config
        name_parts.each do |np|
          cur = config[np]
        end

        case @type
        when :boolean
          return TRUE_VALUES.includes?(cur.as_s)
        when :string
          return cur.as_s
        when :integer
          begin
            return cur.as_i
          rescue ArgumentError

          end
        when :float
          begin
            return cur.as_f
          rescue ArgumentError

          end
        when :array
          return cur.as_a
        end
      else
        return @default
      end
    end

    class InvalidSettingType < Exception
    end
  end
end