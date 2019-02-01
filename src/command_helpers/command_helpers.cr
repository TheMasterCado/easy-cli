require "readline"

module Easy_CLI
    module CommandHelpers
        extend self

        def prompt(question, new_line = false)
            input : String | Nil = nil
            pr = question + " "
            pr += "\n" if new_line
            while input.nil?
                input = Readline.readline(pr)
                input = nil if !input.nil? && input.strip.empty?
            end
            input.strip
        end
    end
end