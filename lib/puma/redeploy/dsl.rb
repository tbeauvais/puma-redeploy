# frozen_string_literal: true

module Puma
  # Allowed options for puma redeploy
  class DSL
    def redeploy_watch_file(file_name)
      @options[:redeploy_watch_file] = file_name
    end

    def redeploy_watch_delay(delay_time)
      @options[:redeploy_watch_delay] = delay_time
    end

    def redeploy_debug(enable: true)
      @options[:redeploy_debug] = enable
    end
  end
end
