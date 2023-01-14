# frozen_string_literal: true

require 'forwardable'

module Puma
  module Redeploy
    # file based redeploy handler
    class FileHandler
      extend Forwardable
      def initialize(redeploy_watch_file:, deployer:, logger:)
        @redeploy_watch_file = redeploy_watch_file
        @logger = logger
        @touched_at = touched_at
        @deployer = deployer
      end

      def_delegators :@deployer, :deploy
      def needs_redeploy?
        return false unless (mtime = touched_at) != @touched_at

        @touched_at = mtime
        true
      end

      def archive_file
        File.read(redeploy_watch_file)&.strip
      end

      private

      attr_accessor :redeploy_watch_file, :logger

      def touched_at
        if File.exist?(redeploy_watch_file)
          File.mtime(redeploy_watch_file)
        else
          logger.info "Watch file (#{redeploy_watch_file}) does not exist"
          0
        end
      end
    end
  end
end
