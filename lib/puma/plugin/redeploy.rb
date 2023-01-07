# frozen_string_literal: true

require 'puma/plugin'
require 'puma/redeploy/dsl'
require 'puma/redeploy/file_handler'
require 'logger'

Puma::Plugin.create do
  def start(launcher)
    in_background do
      logger = launcher.options[:redeploy_logger] || Logger.new(STDOUT)
      watch_file = launcher.options[:redeploy_watch_file]
      file_handler = Puma::Redeploy::FileHandler.new(redeploy_watch_file: watch_file, logger: logger)

      loop do
        sleep launcher.options[:redeploy_watch_delay] || 30

        if file_handler.needs_redeploy?
          logger.info "Puma phased_restart begin #{Time.now}, file=#{watch_file}"
          launcher.phased_restart
        else
          logger.info "Watch file (#{watch_file}) has not changed"
        end
      end
    end
  end
end
