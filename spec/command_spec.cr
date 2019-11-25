require "./spec_helper"

describe Easy_CLI do
  describe Easy_CLI::CLI do
    it "subclass can be instantiated" do
      cli = TestCLI.new
      cliadv = TestAdvancedCLI.new
    end

    it "can register commands" do
      cli = TestCLI.new
      cliadv = TestAdvancedCLI.new
      cli.register(TestCommand.new)
      cliadv.register(TestCommand.new)
    end

    it "can register subcommand" do
      cli = TestCLI.new
      cli.register(TestCommand.new) do |command|
        command.register(TestCommand.new)
      end
    end

    it "raises error when registering the same command twice" do
      cli = TestCLI.new
      cli2 = TestCLI.new
      command = TestCommand.new
      cli.register(command)
      expect_raises(Easy_CLI::Command::CommandRegisteredTwice) do
        cli2.register(command)
      end
    end

    it "raises error when registering two commands with the same name" do
      cli = TestCLI.new
      command = TestCommand.new
      command2 = TestCommand.new
      cli.register(command)
      expect_raises(Easy_CLI::Command::CommandNameNotUnique) do
        cli.register(command2)
      end
    end

    it "correctly run" do
      cli = TestCLI.new
      cli.register(TestCommand.new)
      cli.run(["command"])

      cliadv = TestAdvancedCLI.new
      cliadv.register(TestCommand.new)
      cliadv.run(["command"])
    end
  end

  describe Easy_CLI::Command do
    it "subclass can be instantiated" do
      command = TestCommand.new
    end

    it "raises error when defining two options with the same long/short flag" do
      expect_raises(Easy_CLI::Command::OptionNameNotUnique) do
        command = TestCommandSameOptionName.new
      end
    end

    it "correctly get the cli it is associated with" do
      cli = TestCLI.new
      command = TestCommand.new
      cli.register(command)
      cli.should be(command.cli)
      cli.responds_to?(:version).should be_true
      cli.responds_to?(:logger).should be_true
      cli.cli.should be(cli)
    end
  end
end
