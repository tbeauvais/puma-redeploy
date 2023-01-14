# frozen_string_literal: true

require 'forwardable'

module Puma
  module Redeploy
    # file based redeploy handler
    class FileHandler
      extend Forwardable
      attr_reader :watch_file

      def initialize(watch_file:, deployer:, logger:)
        @watch_file = watch_file
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
        File.read(watch_file)&.strip
      end

      private

      attr_accessor :logger

      def touched_at
        if File.exist?(watch_file)
          File.mtime(watch_file)
        else
          logger.info "Watch file (#{watch_file}) does not exist"
          0
        end
      end
    end
  end
end
