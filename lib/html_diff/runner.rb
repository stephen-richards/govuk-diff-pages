require_relative '../root'
require_relative 'differ'
require_relative '../app_config'
require 'yaml'

module HtmlDiff
  class Runner
    def initialize
      @config = AppConfig.new
      @govuk_pages = YAML.load_file(GOVUK_PAGES_FILE)
      @gallery_template = File.read("#{ROOT_DIR}/lib/html_diff/assets/gallery_template.erb")
      @differ = Differ.new(@config)
    end

    def run
      @govuk_pages.each do |page|
        @differ.diff(page)
      end
      create_gallery_page
    end

  private
    def create_gallery_page
      @result_hash = @differ.differing_pages
      shots_dir = "#{ROOT_DIR}/#{@config.html_diff.directory}"
      Dir.mkdir(shots_dir) unless Dir.exist?(shots_dir)
      renderer = ERB.new(@gallery_template)
      File.open("#{shots_dir}/gallery.html", "w") do |fp|
        fp.puts renderer.result(binding)
      end
      display_browser_message(shots_dir)
    end

    def display_browser_message(shots_dir)
      puts "View the gallery of HTML diffs in your browser:"
      puts "         file://#{shots_dir}/gallery.html"
    end
  end
end
