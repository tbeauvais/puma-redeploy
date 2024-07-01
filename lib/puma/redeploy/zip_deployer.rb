# frozen_string_literal: true

require 'open3'

module Puma
  module Redeploy
    # Deploys zip archive
    class ZipDeployer
      def initialize(target:, logger:)
        @target = target
        @logger = logger
      end

      def deploy(source:)
        return unless source

        Dir.chdir(@target) do
          stdout, stderr, status = Open3.capture3("unzip -o -K #{source}")
          @logger.info "stdout: #{stdout}"
          @logger.info "stderr: #{stderr}"
          @logger.info "status: #{status&.exitstatus}"
        end
      end
    end
  end
end
