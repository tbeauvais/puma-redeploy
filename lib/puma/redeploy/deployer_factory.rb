# frozen_string_literal: true

module Puma
  module Redeploy
    # Creates instance if deployer implementation
    class DeployerFactory
      def self.create(target:, watch_file:, logger:)
        file_deployer = Puma::Redeploy::FileDeployer.new(target: target, logger: logger)
        Puma::Redeploy::FileHandler.new(redeploy_watch_file: watch_file, deployer: file_deployer, logger: logger)
      end
    end
  end
end
