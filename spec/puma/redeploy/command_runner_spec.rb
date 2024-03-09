# frozen_string_literal: true

require 'rspec'

RSpec.describe Puma::Redeploy::CommandRunner do
  subject(:command_runner) { described_class.new(commands:, logger:, runner:) }

  let(:commands) { ['ls'] }
  let(:status_code) { 0 }
  let(:status) { instance_double(Process::Status, exitstatus: status_code) }
  let(:logger) { instance_double(Logger, info: nil, error: nil) }
  let(:results) { ['success', '', status] }
  let(:runner) { class_double(Open3, capture3: results) }

  describe '#run' do
    it 'invokes runner to execute command' do
      command_runner.run
      expect(runner).to have_received(:capture3).with('ls')
    end

    it 'logs command' do
      command_runner.run
      expect(logger).to have_received(:info).with('running command: ls')
    end

    it 'logs stdout' do
      command_runner.run
      expect(logger).to have_received(:info).with('command stdout: success')
    end

    it 'does not log stderr' do
      command_runner.run
      expect(logger).not_to have_received(:error)
    end

    it 'logs exit status' do
      command_runner.run
      expect(logger).to have_received(:info).with('command status: 0')
    end

    context 'with error' do
      let(:results) { ['failed', 'error processing', status] }
      let(:status_code) { 1 }

      it 'logs stderr' do
        command_runner.run
        expect(logger).to have_received(:error).with('command stderr: error processing')
      end
    end

    context 'with nil commands' do
      let(:commands) { nil }

      it 'does not try to run command' do
        command_runner.run
        expect(runner).not_to have_received(:capture3)
      end
    end
  end
end
