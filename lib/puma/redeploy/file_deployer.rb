# frozen_string_literal: true

require 'zip'

module Puma
  module Redeploy
    # Deploys file based archive
    class FileDeployer
      def initialize(source:, target:, logger:)
        @source = source
        @target = target
        @logger = logger
      end

      def deploy
        Zip::File.open(@source) do |zip_file|
          # TODO: Can we do this in one call rather than entry by entry?
          zip_file.each do |entry|
            @logger.info "Extracting #{entry.name}"
            entry.extract(@target)
          end
        end
      end
    end
  end
end
