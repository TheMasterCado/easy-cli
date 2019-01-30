require "yaml"
require "../setting"

module Easy_CLI
    abstract class Config

        getter settings = [] of Setting
        getter file = ""
        getter configuration : YAML::Any

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
                raise SettingNameNotUnique.new("A Setting named '#{full_name}' is already defined.")
            else
                @settings << Setting.new(full_name, type, default)
            end
        end

        def load
            if File.exists?(@file)
                @configuration = YAML.parse(File.read(@file))
            end
        end

        def get(full_name)
            if !self.has_setting?
                raise SettingNotFound.new("No setting named '#{full_name}' has been defined.")
            end

            return self.get_setting(full_name).find_in(@configuration)
        end

        class SettingNameNotUnique < Exception
        end

        class SettingNotFound < Exception
        end

        class ConfigurationNotLoaded < Exception
        end

    end
end
