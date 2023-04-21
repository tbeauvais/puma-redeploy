# frozen_string_literal: true

require 'forwardable'

module Puma
  module Redeploy
    # base redeploy handler
    class BaseHandler
      extend Forwardable
      attr_reader :watch_file

      def initialize(watch_file:, deployer:, logger:)
        @watch_file = watch_file
        @logger = logger
        @deployer = deployer
      end

      def needs_redeploy?
        return false unless (mtime = touched_at) != @touched_at

        @touched_at = mtime
        true
      end

      def_delegators :@deployer, :deploy

      private

      attr_accessor :logger
    end
  end
end
