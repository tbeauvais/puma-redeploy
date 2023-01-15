# frozen_string_literal: true

require 'zip'

module Puma
  module Redeploy
    # Deploys file based archive
    class FileDeployer
      def initialize(target:, logger:)
        @target = target
        @logger = logger
      end

      def deploy(source:)
        Zip::File.open(source) do |zip_file|
          # TODO: Can we do this in one call rather than entry by entry?
          zip_file.each do |entry|
            @logger.info "Extracting #{entry.name}"
            file_path = File.join(@target, entry.name)
            zip_file.extract(entry, file_path)
          end
        end
      end
    end
  end
end
