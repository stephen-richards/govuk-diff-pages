require 'nokogiri'
require 'diffy'

module HtmlDiff
  class Differ
    REPLACEMENTS = {
      'https://www-origin.staging.publishing.service.gov.uk' => 'https://www.gov.uk',
      'https://www-origin.publishing.service.gov.uk' => 'https://www.gov.uk',
      'https://assets-origin.staging.publishing.service.gov.uk' => 'https://assets.digital.cabinet-office.gov.uk',
      /https:\/\/assets\.digital\.cabinet-office\.gov\.uk\/specialist-frontend\/application-[0-9a-f]{32}\.js/ => 'https://assets.digital.cabinet-office.gov.uk/specialist-frontend/application-7463fa64f198b6568dc121dae41d44b1.js',
    }

    attr_reader :differing_pages

    def initialize(config)
      @config = config
      @template = File.read "#{ROOT_DIR}/lib/html_diff/assets/html_diff_template.erb"
      @diff_dir = "#{ROOT_DIR}/#{@config.html_diff.directory}"
      reset_html_diffs_dir
      @differing_pages = {}
    end

    def diff(base_path)
      staging_html = get_normalized_html(staging_url(base_path))
      production_html = get_normalized_html(production_url(base_path))
      diffy = Diffy::Diff.new(production_html, staging_html, context: 3)
      unless diffy.diff == ""
        write_diff_page(base_path, diffy.to_s(:html))
        @differing_pages[base_path] = html_diff_filename(base_path)
      end
    end

  private
    def reset_html_diffs_dir
      Dir.mkdir(@diff_dir) unless Dir.exist?(@diff_dir)
      FileUtils.rm Dir.glob("#{@diff_dir}/*")
    end

    def write_diff_page(base_path, diff_string)
      renderer = ERB.new(@template)
      File.open(html_diff_filename(base_path), "w") do |fp|
        fp.puts renderer.result(binding)
      end
    end

    def html_diff_filename(base_path)
      "#{ROOT_DIR}/#{@config.html_diff.directory}/#{safe_filename(base_path)}.html"
    end

    def safe_filename(base_path)
      remove_starting_and_trailing_slash(base_path).tr('/', '.')
    end

    def remove_starting_and_trailing_slash(base_path)
      base_path.sub(/^\//, '').sub(/\/$/, '')
    end

    def get_normalized_html(url)
      body_html = Nokogiri::HTML(fetch_html(url)).css('body').to_s
      REPLACEMENTS.each do |original, replacement|
        body_html.gsub!(original, replacement)
      end
      body_html
    end

    def fetch_html(url)
      %x[ curl -s #{url} ]
    end

    def production_url(base_path)
      "#{@config.domains.production}#{base_path}"
    end

    def staging_url(base_path)
      "#{@config.domains.staging}#{base_path}"
    end
  end
end
