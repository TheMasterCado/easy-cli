require "option_parser"
require "../command_helpers"
require "../command"
require "../option"

module Easy_CLI
  module Parser
    extend self

    def parse_command(args, registry)
      cur_command = registry
      cur_options = [] of String
      args.each_with_index do |arg, idx|
        if arg.starts_with?('-')
          cur_options = args[idx..-1]
          break
        elsif cur_command.has_command?(arg)
          cur_command = cur_command.get_command(arg)
        elsif cur_command.all_arguments.size > 0
          cur_options = args[idx..-1]
          break
        else
          if idx == 0
            STDERR.puts "ERROR: '#{arg}' is not a valid command.\n"
          else
            STDERR.puts "ERROR: '#{arg}' is not a valid subcommand for '#{cur_command.absolute_call_name}'.\n"
          end
          puts cur_command.usage
          exit(1)
        end
      end
      cur_command
    end

    def parse_options(args, command, std_opts)
      parsed_args = command.options_defaults
      command_arguments = command.all_arguments
      cur_options = args
      command.call_name
      args.each_with_index do |arg, idx|
        if arg == command.call_name
          cur_options = args[idx + 1..-1]
          break
        end
      end
      option_parser = OptionParser.new do |parser|
        parser.banner = command.usage(with_options: true)
        command.all_options.each do |opt|
          case opt.type
          when :boolean
            if opt.short_flag
              parser.on("#{opt.short_flag}", "#{opt.long_flag}", opt.desc) { parsed_args[opt.name] = true }
            else
              parser.on("#{opt.long_flag}", opt.desc) { parsed_args[opt.name] = true }
            end
          when :string
            if opt.short_flag
              parser.on("#{opt.short_flag} #{opt.name.upcase}", "#{opt.long_flag}=#{opt.name.upcase}", opt.desc) { |val| parsed_args[opt.name] = val }
            else
              parser.on("#{opt.long_flag}=#{opt.name.upcase}", opt.desc) { |val| parsed_args[opt.name] = val }
            end
          when :integer
            if opt.short_flag
              parser.on("#{opt.short_flag} #{opt.name.upcase}", "#{opt.long_flag}=#{opt.name.upcase}", opt.desc) do |val|
                begin
                  parsed_args[opt.name] = val.to_i
                rescue ArgumentError
                  STDERR.puts "ERROR: Value for '#{opt.long_flag}' is not a valid integer."
                  puts parser
                  exit(1)
                end
              end
            else
              parser.on("#{opt.long_flag}=#{opt.name.upcase}", opt.desc) do |val|
                begin
                  parsed_args[opt.name] = val.to_i
                rescue ArgumentError
                  STDERR.puts "ERROR: Value for '#{opt.long_flag}' is not a valid integer."
                  puts parser
                  exit(1)
                end
              end
            end
          when :float
            if opt.short_flag
              parser.on("#{opt.short_flag} #{opt.name.upcase}", "#{opt.long_flag}=#{opt.name.upcase}", opt.desc) do |val|
                begin
                  parsed_args[opt.name] = val.to_f
                rescue ArgumentError
                  STDERR.puts "ERROR: Value for '#{opt.long_flag}' is not a valid float."
                  puts parser
                  exit(1)
                end
              end
            else
              parser.on("#{opt.long_flag}=#{opt.name.upcase}", opt.desc) do |val|
                begin
                  parsed_args[opt.name] = val.to_f
                rescue ArgumentError
                  STDERR.puts "ERROR: Value for '#{opt.long_flag}' is not a valid float."
                  puts parser
                  exit(1)
                end
              end
            end
          when :array
            if opt.short_flag
              parser.on("#{opt.short_flag} #{opt.name.upcase},...", "#{opt.long_flag}=#{opt.name.upcase},...", opt.desc) { |items| parsed_args[opt.name] = items.split(',') }
            else
              parser.on("#{opt.long_flag}=#{opt.name.upcase},...", opt.desc) { |items| parsed_args[opt.name] = items.split(',') }
            end
          end
        end
        parser.on("-h", "--help", "Show this help") do
          puts parser
          exit(0)
        end
        if std_opts[:version]
          parser.on("-v", "--version", "Show version") do
            puts command.cli.version
            exit(0)
          end
        end
        parsed_args["yes"] = false
        if std_opts[:yes]
          parser.on("-y", "--yes", "Do not ask for confirmation and assume yes") { parsed_args["yes"] = true }
        end
        if std_opts[:verb]
          parser.on("--verb=0-9", "Set verbosity for execution") do |val|
            val_i = -1
            begin
              val_i = val.to_i
            rescue ArgumentError
              STDERR.puts "ERROR: Value for '--verb' is not a valid integer."
              puts parser
              exit(1)
            end
            if !(0..9).includes?(val_i)
              STDERR.puts "ERROR: Value for '--verb' is not between 0 and 9."
              puts parser
              exit(1)
            end
            parsed_args["verb"] = val_i
          end
        end
        parser.unknown_args do |arguments|
          if arguments.size != command_arguments.size
            arguments.each do |arg|
              if arg.starts_with?('-')
                STDERR.puts "ERROR: '#{arg}' is not a valid option."
                puts parser
                exit(1)
              end
            end
            STDERR.puts "ERROR: Invalid number of arguments for '#{command.absolute_call_name}' (given #{arguments.size}, expected #{command_arguments.size})."
            puts parser
            exit(1)
          end
          command_arguments.each_with_index do |arg, idx|
            parsed_args[arg] = arguments[idx]
          end
        end
        parser.invalid_option do |flag|
          STDERR.puts "ERROR: '#{flag}' is not a valid option."
          puts parser
          exit(1)
        end
        parser.missing_option do |flag|
          STDERR.puts "ERROR: No value provided for '#{flag}'."
          puts parser
          exit(1)
        end
      end
      option_parser.parse(cur_options)
      parsed_args
    end

    def ask_for_required_options(command, options)
      command.all_options.each do |opt|
        if opt.required && options[opt.name].nil?
          options[opt.name] = CommandHelpers.prompt(opt.prompt)
        end
      end
    end
  end
end
