require "yaml"
require "../setting"

module Easy_CLI
    abstract class Config

        # How the fuck to I do this
        getter settings = [] of Setting
        getter file: String = ""
        getter configuration = [] of Setting

        abstract def initialize
        
        def file(path)
            @file = path
        end

        def setting(name, type, default = nil, required = false)
            @settings << Setting.new(name, type, default, required)
        end

        def load_file
            if File.exists?(@file)
                YAML.parse(File.read(@file))
            end
        end

        def validate

        end

    end
end
