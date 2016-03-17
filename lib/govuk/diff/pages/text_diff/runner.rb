module Govuk
  module Diff
    module Pages
      module TextDiff
        class Runner
          def initialize(
            pages: Array.new,
            differ: Differ.new,
            retriever: Retriever.new,
            formatter: Formatter.new,
            renderer: Renderer.new,
            left_domain: "www-origin.staging.publishing.service.gov.uk",
            right_domain: "www-origin.publishing.service.gov.uk"
          )
            @pages     = pages
            @differ    = differ
            @retriever = retriever
            @formatter = formatter
            @renderer  = renderer
            @left_domain  = left_domain
            @right_domain = right_domain
          end

          def run
            responses = @pages.inject([]) do |response, page|
              left  = @retriever.call("https://#{@left_domain}/#{page}")
              right = @retriever.call("https://#{@right_domain}/#{page}")

              response << @differ.diff(
                @formatter.call(left),
                @formatter.call(right)
              )
            end

            @renderer.call(responses)
          end
        end
      end
    end
  end
end
