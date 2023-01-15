# frozen_string_literal: true

require 'rspec'

RSpec.describe Puma::Redeploy::FileDeployer do
  subject(:file_deployer) { described_class.new(target: deploy_dir, logger: logger) }

  let(:deploy_dir) { Dir.mktmpdir }
  let(:archive_file) { 'spec/support_files/app_0.0.1.zip' }
  let(:logger) { instance_double(Logger, info: nil) }

  after do
    FileUtils.rm_rf deploy_dir
  end

  context 'when archive exists' do
    it 'extracts contents' do
      expect { file_deployer.deploy(source: archive_file) }.to change { Dir.entries(deploy_dir).length }.from(2).to(3)
    end
  end
end
