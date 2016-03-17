module Govuk
  module Diff
    module Pages
      class UrlChecker
        def initialize(config)
          @config = config
          @govuk_regex = /^#{@config.domains.production}/
          @parameterised_url_regex = /\?/
          @relative_path_regex = /^\//
        end

        # returns true if non parameterised and a relative or govuk url
        def valid?(url)
          if url =~ @parameterised_url_regex # question mark denotes it has parameters - we don't want those
            false
          elsif url =~ @relative_path_regex # starts with slash - so is a path on govuk website
            true
          elsif url =~ @govuk_regex # gov uk full link
            true
          else
            false
          end
        end

        def normalize(url)
          raise "Not GOVUK url: #{url}" unless valid?(url)
          url.sub(@govuk_regex, '')
        end

        def production_url(url)
          "#{@config.domains.production}#{normalize(url)}"
        end
      end
    end
  end
end
