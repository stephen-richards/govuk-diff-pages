require_relative '../lib/wraith_config_generator'

describe WraithConfigGenerator do
  let(:settings_file) { "#{ROOT_DIR}/config/settings.yml"}
  let(:standard_config) {
    {
      "domains" => {
        "production" => "https://www.gov.uk",
        "staging" => "https://www-origin.staging.publishing.service.gov.uk"
      },
      "hard_coded_pages" => {
        'hmrc' => 'https://www.gov.uk/hmrc',
        'dfe' => 'https://www.gov.uk/dfe'
      },
      "page_indexer" => {
        "max_formats" => 100,
        "max_pages_per_format" => 10
      },
      "wraith" => {
        "browser" => {
          "phantomjs" => "phantomjs"
        },
        "directory" => "shots",
        "screen_widths" => [768, 1024],
         "mode" => "diffs_first",
         "fuzz" => "5%",
         "threshold" => 5
      },
      'verbose' => false,
    }
  }

  let(:govuk_pages) {
    %w{
      /bank-holidays
      /benefits-calculators
      /browse/abroad/passports
      /government/ministers/deputy-prime-minister
      http://www.eastdevon.gov.uk
      http://www.eaststaffsbc.gov.uk/
      https://www.gov.uk/government/ministers
      https://www.gov.uk/government/publications
    }
  }

  let(:generator) { WraithConfigGenerator.new }
  let(:generated_config) { generator.instance_variable_get(:@wraith_config) }

  describe '#run' do
    before(:each) do
      expect(YAML).to receive(:load_file).with(settings_file).and_return(standard_config)
      expect(YAML).to receive(:load_file).with(GOVUK_PAGES_FILE).and_return(govuk_pages)
      allow(File).to receive(:exist?).with(GOVUK_PAGES_FILE).and_return(true)
    end

    it 'should pull in the  wraith section from the settings file' do
      generator.run
      expect(generated_config['domains']).to eq(standard_config['domains'])
      expect(generated_config['browser']).to eq(standard_config['wraith']['browser'])
      expect(generated_config['directory']).to eq(standard_config['wraith']['directory'])
      expect(generated_config['screen_widths']).to eq(standard_config['wraith']['screen_widths'])
      expect(generated_config['mode']).to eq(standard_config['wraith']['mode'])
      expect(generated_config['fuzz']).to eq(standard_config['wraith']['fuzz'])
      expect(generated_config['threshold']).to eq(standard_config['wraith']['threshold'])
    end

    it 'should load the paths from govuk_pages file and add in the hard coded pages' do
      generator.run
      expected_paths = {
        'bank-holidays' => '/bank-holidays',
        'benefits-calculators' => '/benefits-calculators',
        'browse_abroad_passports' => '/browse/abroad/passports',
        'government_ministers_deputy-prime-minister' => '/government/ministers/deputy-prime-minister',
        'government_ministers' => '/government/ministers',
        'government_publications' => '/government/publications',
        'hmrc' => 'https://www.gov.uk/hmrc',
        'dfe' => 'https://www.gov.uk/dfe',
      }
      expect(generated_config['paths']).to eq expected_paths
    end
  end

  describe '.new' do
    it 'should exit if hard coded pages arent in production domain' do
      standard_config['hard_coded_pages']['bad_url1'] = 'http://www.google.com/findme'
      standard_config['hard_coded_pages']['bad_url2'] = 'http://www.tfl.gov.uk/journeyplanner'
      expect(YAML).to receive(:load_file).with(settings_file).and_return(standard_config)
      expect(YAML).to receive(:load_file).with(GOVUK_PAGES_FILE).and_return(govuk_pages)
      allow(File).to receive(:exist?).with(GOVUK_PAGES_FILE).and_return(true)
      expected_error_message = "Invalid config:\n  " +
        "ERROR: Invalid url specified in hard coded pages: 'http://www.google.com/findme'\n  " +
        "ERROR: Invalid url specified in hard coded pages: 'http://www.tfl.gov.uk/journeyplanner'"
      expect {
        WraithConfigGenerator.new
      }.to raise_error ArgumentError, expected_error_message
    end
  end
end
