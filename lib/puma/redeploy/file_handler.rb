# frozen_string_literal: true

module Puma
  module Redeploy
    # file based redeploy handler
    class FileHandler
      def initialize(redeploy_watch_file:)
        @redeploy_watch_file = redeploy_watch_file
        @touched_at = touched_at
      end

      def needs_redeploy?
        return false unless (mtime = touched_at) != @touched_at

        @touched_at = mtime
        true
      end

      private

      attr_accessor :redeploy_watch_file

      def touched_at
        if File.exist?(redeploy_watch_file)
          File.mtime(redeploy_watch_file)
        else
          $stdout.puts "Watch file (#{redeploy_watch_file}) does not exist"
          0
        end
      end
    end
  end
end
