# frozen_string_literal: true

require 'rspec'
require 'fileutils'
require 'tempfile'

RSpec.describe Puma::Redeploy::S3Handler do
  subject(:s3_handler) do
    described_class.new(watch_file:, deployer:, logger:, s3_client:)
  end

  let(:watch_file) { 's3://puma-test-app-archives/watch.me' }
  let(:bucket_name) { 'puma-test-app-archives' }
  let(:object_key) { 'watch.me' }
  let(:head_object) { instance_double(Aws::S3::Types::HeadObjectOutput, last_modified: Time.now) }
  let(:s3_client) { instance_double(Aws::S3::Client, head_object:) }
  let(:deployer) { instance_double(Puma::Redeploy::ZipDeployer, deploy: nil) }
  let(:logger) { instance_double(Logger, info: nil) }

  describe '.needs_redeploy?' do
    it 'calls s3_client.head_object with the correct arguments' do
      expect(s3_client).to receive(:head_object).with(bucket: bucket_name, key: object_key)
      s3_handler
    end

    context 'when object does not exist' do
      let(:head_object) { nil }

      it 'returns false' do
        allow(s3_client).to receive(:head_object).and_return(head_object)
        expect(s3_handler).not_to be_needs_redeploy
      end
    end

    context 'when object exist' do
      context 'without modifications' do
        it 'returns false' do
          expect(s3_handler).not_to be_needs_redeploy
        end
      end

      context 'with modifications' do
        it 'returns true' do
          allow(head_object).to receive(:last_modified).and_return(Time.now,
                                                                   Timecop.travel(Time.now + (60 * 60)).to_time)
          expect(s3_handler).to be_needs_redeploy
        end
      end
    end
  end

  describe '.archive_file' do
    let(:archive_name) { 's3://puma-test-app-archives/archive.1.0.0.zip' }
    let(:archive_bucket_name) { 'puma-test-app-archives' }
    let(:archive_object_key) { 'archive.1.0.0.zip' }

    before do
      # The first call to s3_client.get_object is used to get the s3 watch file contents.
      # The content contains the archive path
      watch_object = instance_double(Aws::S3::Types::GetObjectOutput, body: StringIO.new(archive_name))
      expect(s3_client).to receive(:get_object).and_return(watch_object)

      # The second call to s3_client.get_object is used to get the s3 archive file contents.
      # This would be the zip file but we don't care what's in it.
      archive_object = instance_double(Aws::S3::Types::GetObjectOutput, body: StringIO.new('random data'))
      expect(s3_client).to receive(:get_object).with(bucket: archive_bucket_name,
                                                     key: archive_object_key).and_return(archive_object)
    end

    context 'when file exist' do
      it 'returns archive name' do
        expect(s3_handler.archive_file).to eq archive_object_key
      end
    end
  end
end
