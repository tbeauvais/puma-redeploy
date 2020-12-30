# frozen_string_literal: true

require 'puma/plugin'
require 'puma/redeploy/dsl'

Puma::Plugin.create do
  def start(launcher)
    in_background do
      touched_at = 0

      if File.exist?(launcher.options[:redeploy_watch_file])
        touched_at = File.mtime(launcher.options[:redeploy_watch_file])
      end

      loop do
        sleep launcher.options[:redeploy_watch_delay] || 30

        if File.exist?(launcher.options[:redeploy_watch_file])
          if (mtime = File.mtime(launcher.options[:redeploy_watch_file])) != touched_at
            touched_at = mtime
            $stdout.puts "Puma phased_restart begin #{Time.now}, file=#{launcher.options[:redeploy_watch_file]}"
            launcher.phased_restart
          elsif launcher.options[:redeploy_debug]
            $stdout.puts "Watch file (#{launcher.options[:redeploy_watch_file]}) has not changed"
          end
        else
          $stdout.puts "Watch file (#{launcher.options[:redeploy_watch_file]}) does not exist"
        end
      end
    end
  end
end
