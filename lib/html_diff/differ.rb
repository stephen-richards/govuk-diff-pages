require 'nokogiri'
require 'diffy'


module HtmlDiff
  class Differ

    REPLACEMENTS = {
      'https://www-origin.staging.publishing.service.gov.uk' => 'https://www.gov.uk',
      'https://assets-origin.staging.publishing.service.gov.uk' => 'https://',
    }

    attr_reader :differing_pages

    def initialize(config)
      @config = config
      @template = File.read "#{ROOT_DIR}/lib/html_diff/views/html_diff_template.erb"
      @diff_dir = "#{ROOT_DIR}/#{@config.html_diff.directory}"
      reset_html_diffs_dir
      @differing_pages = []
    end

    def diff(base_path)
      staging_html = get_normalized_html(staging_url(base_path))
      production_html = get_normalized_html(production_url(base_path))
      diffy = Diffy::Diff.new(production_html, staging_html, context: 3)
      unless diffy.diff == ""
        write_diff_page(base_path, diffy.to_s(:html))
        @differing_pages << base_path
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
      remove_starting_and_trailing_slash(base_path).gsub('/', '.')
    end

    def remove_starting_and_trailing_slash(base_path)
      base_path.sub(/^\//, '').sub(/\/$/, '')
    end

    def get_normalized_html(url)
      body_html = Nokogiri::HTML(fetch_html(url)).css('body').to_s
      REPLACEMENTS.each do |original, replacement|
        body_html.gsub!(original, replacement)
      end
      body_html.gsub("\n", '')
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



# html = Nokogiri::HTML(`curl -s #{uri}`).css('body').to_s
#     FILTERS.each do |pattern|
#       html.gsub!(pattern, '')
#     end
#     html


# @diff = Diffy::Diff.new(production_html, staging_html, context: 3).to_s(:html)
