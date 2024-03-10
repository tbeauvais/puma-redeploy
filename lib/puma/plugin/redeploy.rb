# frozen_string_literal: true

require 'puma-redeploy'
require 'logger'

Puma::Plugin.create do
  def start(launcher)
    in_background do
      logger = launcher.options[:redeploy_logger] || Logger.new($stdout)
      watch_file = launcher.options[:redeploy_watch_file]
      handler = Puma::Redeploy::DeployerFactory.create(target: launcher.restart_dir, watch_file:,
                                                       logger:)

      delay = launcher.options[:redeploy_watch_delay] || 30
      monitor_loop(handler, delay, launcher, logger)
    end
  end
end
def monitor_loop(handler, delay, launcher, logger)
  loop do
    sleep delay

    next unless handler.needs_redeploy?

    watch_file_data = handler.watch_file_data
    archive_file = handler.archive_file(watch_file_data[:archive_location])

    logger.info "Puma phased_restart begin file=#{handler.watch_file} archive=#{archive_file}"

    handler.deploy(source: archive_file)

    Puma::Redeploy::CommandRunner.new(commands: watch_file_data[:commands], logger:).run

    launcher.phased_restart
  end
end
