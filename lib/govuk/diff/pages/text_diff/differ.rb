require 'diffy'

module Govuk
  module Diff
    module Pages
      module TextDiff
        class Differ
          def diff(left, right)
            Diffy::Diff.new(left, right).to_s
          end
        end
      end
    end
  end
end
