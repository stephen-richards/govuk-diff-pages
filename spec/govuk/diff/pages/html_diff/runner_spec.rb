describe Govuk::Diff::Pages::HtmlDiff::Runner do
  after(:all) do
    test_output_dir = "#{Govuk::Diff::Pages.root_dir}/html_diff_dir"
    FileUtils.rm_r test_output_dir, secure: true if Dir.exist?(test_output_dir)
  end

  describe '#run' do
    it 'calls differ once for every govuk page' do
      config = double(:AppConfig, html_diff: double(:AppConfig, directory: 'html_diff_dir'))
      expect(Govuk::Diff::Pages::AppConfig).to receive(:new).and_return(config)
      govuk_pages = %w{ page1 page2 page3 }
      expect(YAML).to receive(:load_file).with(Govuk::Diff::Pages.govuk_pages_file).and_return(govuk_pages)
      differ = double :Differ
      expect(differ).to receive(:differing_pages).and_return({})
      expect(Govuk::Diff::Pages::HtmlDiff::Differ).to receive(:new).and_return(differ)
      expect(differ).to receive(:diff).with('page1')
      expect(differ).to receive(:diff).with('page2')
      expect(differ).to receive(:diff).with('page3')

      runner = described_class.new
      expect(runner).to receive(:display_browser_message)
      runner.run
    end
  end
end
