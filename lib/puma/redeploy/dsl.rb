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

    def redeploy_logger(logger)
      @options[:redeploy_logger] = logger
    end

    def redeploy_restart_method(restart_method)
      raise "Invalid Puma restart method: #{restart_method}" unless %i[phased_restart
                                                                       restart].include?(restart_method.to_sym)

      @options[:restart_method] = restart_method
    end
  end
end
