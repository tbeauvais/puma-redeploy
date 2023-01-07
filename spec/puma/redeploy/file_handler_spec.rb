# frozen_string_literal: true

require 'rspec'
require 'fileutils'
require 'tempfile'

RSpec.describe Puma::Redeploy::FileHandler do
  let(:logger) { double('logger', info: nil) }

  subject { Puma::Redeploy::FileHandler.new(redeploy_watch_file: watch_file, logger: logger) }

  describe '.needs_redeploy?' do
    context 'when file does not exist' do
      let(:watch_file) { 'does_not_exist' }

      it 'returns false' do
        expect(subject.needs_redeploy?).to be_falsey
      end
    end

    context 'when file exist' do
      let(:watch_file) { Tempfile.new.path }

      context 'and has not been modified' do
        it 'returns false' do
          expect(subject.needs_redeploy?).to be_falsey
        end
      end

      context 'and has been modified' do
        before do
          subject
          FileUtils.touch watch_file
        end
        it 'returns true' do
          expect(subject.needs_redeploy?).to be_truthy
        end
      end
    end
  end
end
