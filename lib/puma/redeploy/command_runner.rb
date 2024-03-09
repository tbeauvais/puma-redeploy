# frozen_string_literal: true

require 'open3'

module Puma
  module Redeploy
    # Runs commands before redeploy process
    class CommandRunner
      attr_reader :commands, :runner

      def initialize(commands:, logger:, runner: Open3)
        @logger = logger
        @commands = commands || []
        @runner = runner
      end

      def run
        commands.each do |command|
          @logger.info "running command: #{command}"
          stdout, stderr, status = runner.capture3(command)
          @logger.info "command stdout: #{stdout}"
          @logger.info "command status: #{status.exitstatus}"
          @logger.error "command stderr: #{stderr}" if status.exitstatus != 0
        end
      end
    end
  end
end
