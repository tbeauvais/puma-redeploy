# frozen_string_literal: true

require 'forwardable'
require 'aws-sdk-s3'

module Puma
  module Redeploy
    # S3 based redeploy handler
    class S3Handler < BaseHandler
      attr_reader :bucket_name, :object_key, :s3_client

      def initialize(watch_file:, deployer:, logger:, s3_client:)
        super(watch_file:, deployer:, logger:)
        @s3_client = s3_client
        @bucket_name, @object_key = s3_object_reference(watch_file)
        @touched_at = touched_at
      end

      def archive_file
        s3_url = read_watch_object
        return unless s3_url

        archive_bucket_name, archive_object_key = s3_object_reference(s3_url)

        response = s3_client.get_object(bucket: archive_bucket_name, key: archive_object_key)

        file_name = local_file_path(archive_object_key)
        # Write the object data to a local file
        File.binwrite(file_name, response.body.read)
        file_name
      rescue StandardError => e
        logger.warn "Error reading fetching archive file for #{s3_url}. Error:#{e.message}"
      end

      private

      def s3_object_reference(watch_file)
        s3_uri = URI.parse(watch_file)
        [s3_uri.host, s3_uri.path[1..]]
      end

      def local_file_path(object_key)
        File.basename(object_key)
      end

      def read_watch_object
        # Get the object data from S3
        object = s3_client.get_object(bucket: bucket_name, key: object_key)

        object.body.read.strip
      rescue StandardError => e
        logger.warn "Error reading url from  watch file #{bucket_name}/#{object_key}. Error:#{e.message}"
      end

      def touched_at
        head_object = s3_client.head_object(bucket: bucket_name, key: object_key)

        if head_object
          head_object.last_modified
        else
          logger.info "The S3 object #{bucket_name}/#{object_key} does not exist"
          0
        end
      rescue StandardError => e
        logger.warn "Error accessing the S3 object #{bucket_name}/#{object_key}. Error:#{e.message}"
        0
      end
    end
  end
end
