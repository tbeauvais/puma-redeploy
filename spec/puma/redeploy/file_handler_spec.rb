# frozen_string_literal: true

require 'rspec'
require 'fileutils'
require 'tempfile'

RSpec.describe Puma::Redeploy::FileHandler do
  subject(:file_handler) { described_class.new(redeploy_watch_file: watch_file, logger: logger) }

  let(:logger) { instance_double(Logger, info: nil) }

  describe '.needs_redeploy?' do
    context 'when file does not exist' do
      let(:watch_file) { 'does_not_exist' }

      it 'returns false' do
        expect(file_handler).not_to be_needs_redeploy
      end
    end

    context 'when file exist' do
      let(:watch_file) { Tempfile.new.path }

      context 'without modifications' do
        it 'returns false' do
          expect(file_handler).not_to be_needs_redeploy
        end
      end

      context 'with modifications' do
        before do
          file_handler
          Timecop.travel(Time.now + (60 * 60)) do
            FileUtils.touch(watch_file, mtime: Time.now)
          end
        end

        it 'returns true' do
          expect(file_handler).to be_needs_redeploy
        end
      end
    end
  end

  describe '.archive_file' do
    let(:archive_name) { 'archive.1.0.0.zip' }

    context 'when file exist' do
      let(:watch_file) do
        Tempfile.new.tap do |file|
          file.write(archive_name)
          file.close
        end.path
      end

      it 'returns archive name' do
        expect(file_handler.archive_file).to eq archive_name
      end
    end
  end
end
