# frozen_string_literal: true

require 'puma/plugin'
require 'puma/redeploy/dsl'
require 'puma/redeploy/file_handler'

Puma::Plugin.create do
  # rubocop:disable Metrics/AbcSize
  def start(launcher)
    in_background do
      file_handler = Puma::Redeploy::FileHandler.new(redeploy_watch_file: launcher.options[:redeploy_watch_file])

      loop do
        sleep launcher.options[:redeploy_watch_delay] || 30

        if file_handler.needs_redeploy?
          $stdout.puts "Puma phased_restart begin #{Time.now}, file=#{launcher.options[:redeploy_watch_file]}"
          launcher.phased_restart
        else
          $stdout.puts "Watch file (#{launcher.options[:redeploy_watch_file]}) has not changed"
        end
      end
    end
  end
  # rubocop:enable Metrics/AbcSize
end
