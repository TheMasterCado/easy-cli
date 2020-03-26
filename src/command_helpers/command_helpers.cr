module Easy_CLI
  module CommandHelpers
    extend self

    def prompt(question, new_line = false)
      input : String | Nil = nil
      pr = question + " "
      pr += "\n" if new_line
      while input.nil?
        print pr
        input = STDIN.gets
        input = nil if !input.nil? && input.strip.empty?
        STDOUT.puts "\n" if input.nil?
      end
      input.strip
    end
  end
end
