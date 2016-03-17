require 'rest-client'
require 'json'

module Govuk
  module Diff
    module Pages
      class PageSearcher
        def initialize(config, formats)
          @config = config
          @formats = formats
          @pages = []
          @url_checker = UrlChecker.new(@config)
        end

        def run
          @formats.each do |format|
            puts "Getting top #{@config.page_indexer.max_pages_per_format} for format #{format}" if verbose?
            @pages << top_pages_for_format(format)
          end
          @pages.flatten!
        end

        def verbose?
          @config.verbose
        end

      private

        def top_pages_for_format(format)
          result_set = JSON.parse(result_set_for_format(format))
          extract_top_govuk_pages(result_set)
        end

        def extract_top_govuk_pages(result_set)
          links = result_set.fetch('results').collect { |result| result['link'] }
          valid_links = links.select { |link| @url_checker.valid?(link) }
          valid_links.slice(0, @config.page_indexer.max_pages_per_format)
        end

        def result_set_for_format(format)
          url = "#{@config.domains.production}/api/search.json?filter_format=#{format}"
          RestClient.get(url)
        end
      end
    end
  end
end
