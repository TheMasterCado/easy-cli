require "yaml"
require "../setting"

module Easy_CLI
    abstract class Config

        getter settings = [] of Setting
        getter file = ""
        getter configuration = {} of String => Nil | Int32 | String | Array(String)

        abstract def initialize
        
        def file(path)
            @file = path
        end

        def has_setting?(setting)
            @settings.each do |s|
                return true if s.full_name == setting
            end
        end

        def get_setting(setting)
            @settings.each do |s|
                return s if s.full_name == setting
            end
            return @settings.first
        end

        def setting(full_name, type, default = nil)
            if self.has_setting?
                SettingNameNotUnique
            else
                @settings << Setting.new(full_name, type, default)
            end
        end

        def load_file
            if File.exists?(@file)
                YAML.parse(File.read(@file))
            end
        end

        def validate

        end

        class SettingNameNotUnique < Exception
        end

    end
end
