require_relative '../../lib/html_diff/runner'
require_relative '../../lib/root'

module HtmlDiff
  describe Runner do
    after(:all) do
      test_output_dir = "#{ROOT_DIR}/html_diff_dir"
      FileUtils.rm_r test_output_dir, secure: true if Dir.exist?(test_output_dir)
    end

    describe '#run' do
      it 'calls differ once for every govuk page' do
        config = double(AppConfig, html_diff: double(AppConfig, directory: 'html_diff_dir'))
        expect(AppConfig).to receive(:new).and_return(config)
        govuk_pages = %w{ page1 page2 page3 }
        expect(YAML).to receive(:load_file).with(GOVUK_PAGES_FILE).and_return(govuk_pages)
        differ = double Differ
        expect(differ).to receive(:differing_pages).and_return({})
        expect(Differ).to receive(:new).and_return(differ)
        expect(differ).to receive(:diff).with('page1')
        expect(differ).to receive(:diff).with('page2')
        expect(differ).to receive(:diff).with('page3')

        runner = Runner.new
        expect(runner).to receive(:display_browser_message)
        runner.run
      end
    end
  end
end
