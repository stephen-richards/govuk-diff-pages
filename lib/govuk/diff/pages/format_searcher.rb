require 'rest-client'
require 'json'

module Govuk
  module Diff
    module Pages
      class FormatSearcher
        def initialize(config)
          @config = config
        end

        def run
          puts "Getting list of formats in GOVUK" if verbose?
          response = get_facets
          extract_formats(response)
        end

        def verbose?
          @config.verbose
        end

      private

        def extract_formats(response)
          parsed_response = JSON.parse(response)
          options = parsed_response.fetch('facets').fetch('format').fetch('options')
          options.map { |o| o['value']['slug'] }
        end

        def get_facets
          url = "#{@config.domains.production}/api/search.json?facet_format=#{@config.page_indexer.max_formats}"
          RestClient.get(url)
        end
      end
    end
  end
end
