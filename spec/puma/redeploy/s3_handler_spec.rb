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
  let(:s3_client) { instance_double(Aws::S3::Client) }
  let(:deployer) { instance_double(Puma::Redeploy::ZipDeployer, deploy: nil) }
  let(:logger) { instance_double(Logger, info: nil) }

  describe '.needs_redeploy?' do
    before do
      allow(s3_client).to receive(:head_object).with(bucket: bucket_name, key: object_key).and_return(head_object)
    end

    context 'when object does not exist' do
      let(:head_object) { nil }

      it 'returns false' do
        s3_handler.needs_redeploy?
        expect(s3_handler).not_to be_needs_redeploy
      end
    end

    context 'when file exist' do
      context 'without modifications' do
        it 'returns false' do
          s3_handler.needs_redeploy?
          expect(s3_handler).not_to be_needs_redeploy
        end
      end

      context 'with modifications' do
        before do
          expect(head_object).to receive(:last_modified).and_return(Time.now)
          Timecop.travel(Time.now + (60 * 60)) do
            expect(head_object).to receive(:last_modified).and_return(Time.now)
          end
        end

        it 'returns true' do
          s3_handler.needs_redeploy?
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
      allow(s3_client).to receive(:head_object).with(bucket: bucket_name, key: object_key).and_return(head_object)

      watch_object = instance_double(Aws::S3::Types::GetObjectOutput, body: StringIO.new(archive_name))
      expect(s3_client).to receive(:get_object).with(bucket: bucket_name, key: object_key).and_return(watch_object)

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