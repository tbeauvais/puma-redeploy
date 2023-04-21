# frozen_string_literal: true

require 'rspec'

RSpec.describe Puma::Redeploy::DeployerFactory do
  let(:logger) { instance_double(Logger, info: nil) }

  context 'when watch is a file path' do
    it 'returns a file handler' do
      expect(described_class.create(target: '/app', watch_file: 'watch.me',
                                    logger:)).to be_a(Puma::Redeploy::FileHandler)
    end
  end

  context 'when watch is a s3 bucket' do
    it 'returns an s3 handler' do
      expect(described_class.create(target: '/app', watch_file: 's3://bucket/watch.me',
                                    logger:)).to be_a(Puma::Redeploy::S3Handler)
    end
  end
end
