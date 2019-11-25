require "./spec_helper"

describe Easy_CLI do
  describe Easy_CLI::Logger do
    it "subclass can be instantiated" do
        logger = TestLogger.new
    end
  end
end
