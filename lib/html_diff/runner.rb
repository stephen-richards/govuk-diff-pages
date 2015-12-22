require_relative '../root'
require_relative 'differ'
require_relative '../app_config'
require 'yaml'

module HtmlDiff
  class Runner
    def initialize
      @template = File.read(File.dirname(__FILE__) + '/views/html_diff_template.erb')
      @config = AppConfig.new
      @govuk_pages = YAML.load_file(GOVUK_PAGES_FILE)
      @differ = Differ.new(@config)
    end

    def run
      @govuk_pages.each { |page| @differ.diff(page) }
    end
  end
end


