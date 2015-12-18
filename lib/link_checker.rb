require 'yaml'
require 'rest-client'
require_relative 'root'
require_relative 'app_config'
require_relative 'url_checker'



class LinkChecker
  def initialize
    puts "#{ROOT_DIR}/config/govuk_pages.yml"
    @urls = YAML.load_file("#{ROOT_DIR}/config/govuk_pages.yml")
    @config = AppConfig.new
    @results = Hash.new { |hash, key| hash[key] = Array.new }
    @num_links = 0
    @url_checker = UrlChecker.new(@config)
  end

  def run
    @urls.each { |u| make_request(u) }
    print_results
  end

private
  def print_results
    puts "Number of pages checked: #{@num_links}"
    puts "  of which:"
    @results.each do |code, links|
      puts "   #{links.size} responded with #{code}"
    end
  end

  def make_request(url)
    @num_links += 1
    normalized_url = @url_checker.production_url(url)
    5.times do
      begin
        success = true
        print "GET #{normalized_url}  "
        response = RestClient.get "#{normalized_url}"
        @results[response.code] << url
        puts "Response #{response.code}"
      rescue => e
        success = false
        puts "\nERROR GETTING #{normalized_url}"
        puts "#{e.class} ::: #{e.message}"
        @results['EX'] << url
      end
      break if success
    end
  end
end
