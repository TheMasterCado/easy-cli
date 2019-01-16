require "../option"

module Easy_CLI
  class CLI
    abstract class Command
      getter call_name = ""
      getter description = ""
      getter parent : Command | Nil = nil
      getter commands = [] of Command
      getter options = [] of Option

      abstract def call(options)

      def options_defaults
        option_defaults = {} of String => String | Bool | Int32 | Array(String) | Nil
        all_options.map { |option| option_defaults[option.name] = option.default }
        option_defaults
      end
      
      def all_options
        if parent = @parent
          my_short_flags = @options.map { |o| o.short_flag }
          my_long_flags = @options.map { |o| o.long_flag }
          @options + parent.all_options.select { |o| !my_short_flags.includes?(o.short_flag) && !my_long_flags.includes?(o.long_flag) }
        else
          @options
        end
      end

      def attach_to(parent)
        @parent = parent
      end

      def register(command, &block)
        self.register(command)
        yield command
      end

      def register(command)
        if command.attach_to(self)
          @commands << command
        else
          raise CommandException.new("A single Command instance can only be register once.")
        end
      end

      def absolute_call_name
        str = @call_name
        cur_level = self.parent
        while cur_level
          str += "#{cur_level.call_name} #{str}"
          cur_level = cur_level.parent
        end
        str
      end

      def has_command?(command_name)
        @commands.each do |com|
          return true if com.call_name == command_name
        end
      end

      def get_command(command_name)
        @commands.each do |com|
          return com if com.call_name == command_name
        end
        return @commands.first
      end

      def usage(with_options = false)
        message = "Usage: #{self.absolute_call_name}"
        message += " [command]" unless @commands.empty?
        message += " [options]" unless @options.empty?
        message += "\n\nDescription:\n    #{self.description}" unless self.description.empty?
        message += "\n\nCommands:" unless @commands.empty?
        @commands.each do |com|
          a_line = "    #{com.call_name}"
          a_line += " [subcommand]" unless com.commands.empty?
          a_line += " "*(37 - a_line.size) + "#{com.description}" unless com.description.empty?
          message += "\n" + a_line
        end
        message += "\n\nOptions:" if with_options
        message
      end

      macro option(name, type, short_flag, long_flag, default = nil, required = false, desc = "")
        @options << Option.new({{name}}, {{type}}, {{short_flag}}, {{long_flag}}, {{default}}, {{required}}, {{desc}})
      end

      macro desc(d)
        @description = {{d}}
      end

      macro name(n)
        @call_name = {{n}}
      end

      class CommandException < Exception
      end
    end
  end
end
