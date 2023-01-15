# frozen_string_literal: true

require 'puma/plugin'
require 'puma/redeploy/dsl'
require 'puma/redeploy/file_handler'
require 'puma/redeploy/file_deployer'
require 'puma/redeploy/deployer_factory'
require 'logger'

Puma::Plugin.create do
  def start(launcher)
    in_background do
      logger = launcher.options[:redeploy_logger] || Logger.new($stdout)
      watch_file = launcher.options[:redeploy_watch_file]
      file_handler = Puma::Redeploy::DeployerFactory.create(target: launcher.restart_dir, watch_file: watch_file,
                                                            logger: logger)

      delay = launcher.options[:redeploy_watch_delay] || 30
      monitor_loop(file_handler, delay, launcher, logger)
    end
  end
end
def monitor_loop(file_handler, delay, launcher, logger)
  loop do
    sleep delay

    next unless file_handler.needs_redeploy?

    logger.info "Puma phased_restart begin file=#{file_handler.watch_file} archive=#{file_handler.archive_file}"

    file_handler.deploy(source: file_handler.archive_file)

    launcher.phased_restart
  end
end
