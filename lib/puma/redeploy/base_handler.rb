# frozen_string_literal: true

require 'forwardable'
require 'yaml'

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

      def watch_file_data
        watch_file_content = read_watch_object
        results = YAML.safe_load(watch_file_content, symbolize_names: true)
        return results if results.is_a?(Hash)

        # old style where the file contains only the archive location
        { commands: [], archive_location: results }
      end

      private

      attr_accessor :logger
    end
  end
end
