require 'nokogiri'

module Govuk
  module Diff
    module Pages
      module TextDiff
        class Formatter
          def call(html)
            Nokogiri::HTML(html).xpath("//text()").text
          end
        end
      end
    end
  end
end
