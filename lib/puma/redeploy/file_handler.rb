# frozen_string_literal: true

require 'forwardable'

module Puma
  module Redeploy
    # file based redeploy handler
    class FileHandler < BaseHandler
      def initialize(watch_file:, deployer:, logger:)
        super
        @touched_at = touched_at
      end

      def archive_file(archive_location)
        archive_location
      end

      private

      def read_watch_object
        File.read(watch_file).strip
      rescue StandardError => e
        logger.warn "Error reading watch file #{watch_file}. Error:#{e.message}"
        nil
      end

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
