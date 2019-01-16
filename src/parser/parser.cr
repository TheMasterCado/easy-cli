require "option_parser"
require "../command"
require "../option"

module Easy_CLI
  class CLI
    module Parser
      def self.parse_command(args, registry)
        cur_command : Command = registry
        cur_options = [] of String
        args.each_with_index do |arg, idx|
          if arg.starts_with?('-')
            cur_options = args[idx..-1]
            break
          elsif (cur_command.has_command?(arg))
            cur_command = cur_command.get_command(arg)
          else
            if idx == 0
              STDERR.puts "ERROR: '#{arg}' is not a valid command.\n"
            else
              STDERR.puts "ERROR: '#{arg}' is not a valid subcommand for '#{cur_command.absolute_call_name}'.\n"
            end
            STDERR.puts cur_command.usage
            exit(1)
          end
        end
        if cur_command == registry
          STDERR.puts cur_command.usage
          exit(1)
        end
        cur_command
      end

      def self.parse_options(args, command)
        parsed_options = command.options_defaults
        cur_options = args
        # args.each_with_index do |arg, idx|
        #   if arg.starts_with?('-')
        #     cur_options = args[idx..-1]
        #     break
        #   end
        # end
        option_parser = OptionParser.new do |parser|
          parser.banner = command.usage(with_options: true)
          command.all_options.each do |opt|
            case opt.type
            when :boolean
              parser.on("#{opt.short_flag}", "#{opt.long_flag}", opt.desc) { parsed_options[opt.name] = true }
            when :string
              parser.on("#{opt.short_flag} #{opt.name.upcase}", "#{opt.long_flag}=#{opt.name.upcase}", opt.desc) { |val| parsed_options[opt.name] = val }
            when :integer
              parser.on("#{opt.short_flag} #{opt.name.upcase}", "#{opt.long_flag}=#{opt.name.upcase}", opt.desc) do |val|
                begin
                  parsed_options[opt.name] = val.to_i
                rescue ArgumentError
                  STDERR.puts "ERROR: Value for '#{opt.long_flag}' is not a valid integer."
                  STDERR.puts parser
                  exit(1)
                end
              end
            when :array
              parser.on("#{opt.short_flag} #{opt.name.upcase},...", "#{opt.long_flag}=#{opt.name.upcase},...", opt.desc) { |items| parsed_options[opt.name] = items.split(',') }
            else
              raise Command::Option::InvalidOptionType.new("'#(opt.type)' is not a valid type for an option.")
            end
          end
          parser.on("-h", "--help", "Show this help") do 
            puts parser
            exit(0)
          end
          parser.invalid_option do |flag|
            STDERR.puts "ERROR: '#{flag}' is not a valid option."
            STDERR.puts parser
            exit(1)
          end
          parser.missing_option do |flag|
            STDERR.puts "ERROR: No value provided for '#{flag}'."
            STDERR.puts parser
            exit(1)
          end
        end
        option_parser.parse(cur_options)
        parsed_options
      end
    end
  end
end
