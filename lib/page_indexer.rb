# This class is resonsible for getting list of the most popular pages and placing them in a
# file to be used by the html and visual differs

require 'yaml'
require_relative 'root.rb'
require_relative 'format_searcher'
require_relative 'page_searcher'
require_relative 'app_config'

class PageIndexer
  def initialize
    @pages = []
    @config = AppConfig.new("#{ROOT_DIR}/config/settings.yml")
  end

  def run
    formats = FormatSearcher.new(@config).run
    @pages = PageSearcher.new(@config, formats).run
    File.open(GOVUK_PAGES_FILE, 'w') do |fp|
      fp.puts @pages.sort.to_yaml
    end
  end

private
  def get_formats
    @formats = FormatSearcher.new(@config).run
  end
end
