require 'yaml'
require 'securerandom'

module Govuk
  module Diff
    module Pages
      class WraithConfigGenerator
        def initialize
          @config = AppConfig.new
          unless File.exist?(Govuk::Diff::Pages.govuk_pages_file)
            raise "Cannot find file #{Govuk::Diff::Pages.govuk_pages_file}: run 'rake update_page_list' to generate."
          end
          @govuk_pages = YAML.load_file(Govuk::Diff::Pages.govuk_pages_file)
          @url_checker = UrlChecker.new(@config)
          puts "Generating wraith.yaml" if verbose?
          validate_hard_coded_pages
        end

        def run
          @wraith_config = @config.wraith.to_h
          @wraith_config['paths'] = generate_path_list
          @wraith_config['domains'] = @config.domains.to_h
          @wraith_config['browser'] = { 'phantomjs' => 'phantomjs' }
          @wraith_config['phantomjs_options'] = "--ssl-protocol=tlsv1 --ignore-ssl-errors=true"
        end

        def save
          File.open(Govuk::Diff::Pages.wraith_config_file, 'w') do |fp|
            fp.puts YAML.dump(@wraith_config)
          end
        end

        def verbose?
          @config.verbose
        end

      private

        def validate_hard_coded_pages
          errors = []
          @config.hard_coded_pages.to_h.each do |_key, url|
            next if @url_checker.valid?(url)
            errors << "ERROR: Invalid url specified in hard coded pages: '#{url}'"
          end
          print_errors_and_exit(errors) unless errors.empty?
        end

        def print_errors_and_exit(errors)
          raise ArgumentError.new %[Invalid config:\n  #{errors.join("\n  ")}]
        end

        def generate_path_list
          paths = generate_paths_from_govuk_pages_file
          paths.merge(@config.hard_coded_pages.to_h)
        end

        def generate_paths_from_govuk_pages_file
          paths = {}
          @govuk_pages.each do |path|
            next unless @url_checker.valid?(path)
            normalized_path = @url_checker.normalize(path)
            paths[keyify_path(normalized_path)] = normalized_path
          end
          paths
        end

        def normalize_path(path)
          path.sub(/^#{@config.domains.production}/, '')
        end

        def keyify_path(path)
          key = path.sub(/^\//, '').tr("/", "_")
          # YAML DUMP doesn't work with very long keys
          key = SecureRandom.uuid if key.size > 100
          key
        end
      end
    end
  end
end
