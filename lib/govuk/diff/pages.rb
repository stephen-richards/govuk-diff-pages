require "govuk/diff/pages/version"

module Govuk
  module Diff
    module Pages
      autoload :HtmlDiff, 'govuk/diff/pages/html_diff'
      autoload :TextDiff, 'govuk/diff/pages/text_diff'
      autoload :VisualDiff, 'govuk/diff/pages/visual_diff'

      def self.root_dir
        File.dirname __dir__
      end

      def self.shots_dir
        File.expand_path(root_dir + "/../../shots")
      end

      def self.wraith_config_template
        config_file 'wraith.yaml'
      end

      def self.config_file(filename)
        File.expand_path(root_dir + "/../../config/#{filename}")
      end
    end
  end
end
