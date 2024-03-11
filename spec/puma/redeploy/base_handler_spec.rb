# frozen_string_literal: true

require 'rspec'
require 'yaml'

RSpec.describe Puma::Redeploy::BaseHandler do
  subject(:handler) { Puma::Redeploy::FileHandler.new(watch_file:, deployer:, logger:) }

  let(:deployer) { instance_double(Puma::Redeploy::ZipDeployer, deploy: nil) }
  let(:logger) { instance_double(Logger, info: true, warn: true) }

  describe '#watch_file_data' do
    let(:archive_name) { 'archive.1.0.0.zip' }
    let(:watch_file) do
      Tempfile.new.tap do |file|
        file.write(watch_file_content)
        file.close
      end.path
    end

    context 'when file contains yaml' do
      let(:watch_file_content) { { 'commands' => ['ls'], 'archive_location' => archive_name }.to_yaml }

      it 'returns proper hash' do
        expect(handler.watch_file_data).to eq({ commands: ['ls'], archive_location: archive_name })
      end
    end

    context 'when file contains archive name' do
      let(:watch_file_content) { archive_name }

      it 'returns proper hash' do
        expect(handler.watch_file_data).to eq({ commands: [], archive_location: archive_name })
      end
    end

    context 'when file does not exist' do
      let(:watch_file) { 'missing.yml' }

      it 'returns empty hash' do
        expect(handler.watch_file_data).to eq({})
      end
    end
  end
end
