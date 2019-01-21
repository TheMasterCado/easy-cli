require "../option"

module Easy_CLI
  abstract class Command
    getter call_name = ""
    getter description = ""
    getter parent : Command | Nil = nil
    getter commands = [] of Command
    getter options = [] of Option
    getter arguments = [] of String

    abstract def initialize

    abstract def call(args)

    def options_defaults
      defaults = {} of String => String | Bool | Int32 | Array(String) | Nil
      all_options.map { |option| defaults[option.name] = option.default }
      defaults
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

    def all_arguments
      if parent = @parent
        @arguments + parent.all_arguments.select { |a| !@arguments.includes?(a) }
      else
        @arguments
      end
    end

    def attach_to(parent)
      if @parent.nil?
        @parent = parent
      else
        false
      end
    end

    def register(command, &block)
      self.register(command)
      yield command
    end

    def register(command)
      if !self.has_command?(command.call_name)
        if command.attach_to(self)
          @commands << command
        else
          raise CommandRegisteredTwice.new("This Command instance is already registered.")
        end
      else
        raise CommandNameNotUnique.new("This Command already have a subcommand named '#{command.call_name}'.")
      end
    end

    def absolute_call_name
      str = @call_name
      cur_level = self.parent
      while cur_level
        str = "#{cur_level.call_name} #{str}"
        cur_level = cur_level.parent
      end
      str
    end

    def has_command?(command_name)
      @commands.each do |com|
        return true if com.call_name == command_name
      end
    end

    def has_option_or_argument?(name)
      return @options.map { |opt| opt.name }.includes?(name) || @arguments.includes?(name)
    end

    def get_command(command_name)
      @commands.each do |com|
        return com if com.call_name == command_name
      end
      return @commands.first
    end

    def usage(with_options = false)
      message = "Usage: #{self.absolute_call_name}"
      message += " COMMAND" unless @commands.empty?
      self.all_arguments.each do |arg|
        message += " #{arg.underscore.upcase}"
      end
      message += " [options]" if with_options
      message += "\n\nDescription:\n    #{self.description}" unless self.description.empty?
      message += "\n\nCommands:" unless @commands.empty?
      @commands.each do |com|
        a_line = "    #{com.call_name}"
        a_line += " SUBCOMMAND" unless com.commands.empty?
        a_line += " "*(37 - a_line.size) + "#{com.description}" unless com.description.empty?
        message += "\n" + a_line
      end
      message += "\n\nOptions:" if with_options
      message
    end

    def option(name, type, short_flag, long_flag, default = nil, required = false, desc = "")
      if self.has_option_or_argument?(name)
        raise OptionNameNotUnique.new("An Option or Argument named '#{name}' is already defined.")
      else
        @options << Option.new(name, type, short_flag, long_flag, default, required, desc)
      end
    end

    def argument(name)
      if self.has_option_or_argument?(name)
        raise OptionNameNotUnique.new("An Option or Argument named '#{name}' is already defined.")
      else
        @arguments << name
      end
    end

    def desc(d)
      @description = d
    end

    def name(n)
      @call_name = n
    end

    class CommandRegisteredTwice < Exception
    end
    class CommandNameNotUnique < Exception
    end
    class OptionNameNotUnique < Exception
    end
  end
end
