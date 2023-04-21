# frozen_string_literal: true

require 'puma-redeploy'
# require 'puma/plugin'
# require 'puma/redeploy/dsl'
# require 'puma/redeploy/file_handler'
# require 'puma/redeploy/file_deployer'
# require 'puma/redeploy/deployer_factory'
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

    logger.info "Puma phased_restart begin file=#{handler.watch_file} archive=#{handler.archive_file}"

    handler.deploy(source: handler.archive_file)

    launcher.phased_restart
  end
end
