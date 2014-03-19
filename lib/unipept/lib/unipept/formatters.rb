module Unipept
  class Formatter

    def self.formatters
      @@formatters ||= {}
    end

    def self.new_for_format(format)
      begin
        formatters[format].new
      rescue
        formatters[self.default].new
      end
    end

    def self.register(format)
      self.formatters[format.to_s] = self
    end

    def self.available
      self.formatters.keys
    end

    def self.default
      'json'
    end

    # JSON formatted data goes in, something other comes out
    def format(data)
      data
    end
  end

  class JSONFormatter < Formatter
    require 'json'
    register :json

    def format(data)
      data.to_json
    end

  end
  class CSVFormatter < Formatter
    require 'csv'

    register :csv

    def format(data)
      CSV.generate do |csv|
        first = data.first
        if first.kind_of? Array
          first = first.first
        end
        csv << first.keys.map(&:to_s)

        data.each do |o|
          if o.kind_of? Array
            o.each {|h| csv << h.values }
          else
            csv << o.values
          end
        end
      end
    end
  end

  class XMLFormatter < Formatter
    require 'to_xml'

    register :xml

    def format(data)
      data.to_xml
    end

  end


end
