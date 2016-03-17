module Govuk
  module Diff
    module Pages
      module TextDiff
        class Retriever
          def call(url)
            `curl -s #{url}`
          end
        end
      end
    end
  end
end
