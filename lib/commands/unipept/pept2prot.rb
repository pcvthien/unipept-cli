require_relative 'api_runner'

module Unipept::Commands
  class Pept2prot < ApiRunner
    def batch_size
      if options[:all]
        5
      else
        10
      end
    end
  end
end
