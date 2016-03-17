require 'yaml'

module Govuk
  module Diff
    module Pages
      class PageIndexer
        def initialize
          @pages = []
          @config = AppConfig.new("#{Govuk::Diff::Pages.root_dir}/config/settings.yml")
        end

        def run
          formats = FormatSearcher.new(@config).run
          @pages = PageSearcher.new(@config, formats).run
          File.open(Govuk::Diff::Pages.govuk_pages_file, 'w') do |fp|
            fp.puts @pages.sort.to_yaml
          end
        end

      private

        def get_formats
          @formats = FormatSearcher.new(@config).run
        end
      end
    end
  end
end
