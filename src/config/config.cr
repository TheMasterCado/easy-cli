require "yaml"
require "../setting"

module Easy_CLI
    abstract class Config

        @settings = [] of Setting
        @file: String = ""

        abstract def initialize
        
        def file(path)
            @file = path
        end

        def setting(name, type, default = nil, required = false)
            @settings << Setting.new(name, type, default, required)
        end

        def load_file
            
        end

        def validate

        end

    end
end
