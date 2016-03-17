module Govuk
  module Diff
    module Pages
      module TextDiff
        class Renderer
          SEPARATOR = "\n\n".freeze

          def initialize(kernel = Kernel)
            @kernel = kernel
          end

          def call(responses)
            if responses.all?(&:empty?)
              puts 'OK!'
            else
              @kernel.abort responses.join(SEPARATOR)
            end
          end
        end
      end
    end
  end
end
