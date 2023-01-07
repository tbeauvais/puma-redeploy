# frozen_string_literal: true

Dir.glob("#{__dir__}/puma/redeploy/**/*.rb").sort.each { |file| require file }

module Puma
  module Redeploy
    class Error < StandardError; end
    # Your code goes here...
  end
end
