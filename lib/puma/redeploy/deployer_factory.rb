# frozen_string_literal: true

module Puma
  module Redeploy
    # Creates instance of the redeploy handler based on the watch file location
    class DeployerFactory
      def self.create(target:, watch_file:, logger:)
        file_deployer = Puma::Redeploy::ZipDeployer.new(target:, logger:)
        if watch_file.start_with?('s3')
          Puma::Redeploy::S3Handler.new(watch_file:, deployer: file_deployer, logger:, s3_client:)
        else
          Puma::Redeploy::FileHandler.new(watch_file:, deployer: file_deployer, logger:)
        end
      end

      def self.s3_client
        Aws::S3::Client.new
      end
    end
  end
end
