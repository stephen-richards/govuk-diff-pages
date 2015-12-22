require_relative '../../lib/html_diff/runner'
require_relative '../../lib/root'


module HtmlDiff 
  describe Runner do
    describe '#run' do
      it 'calls differ once for every govuk page' do
        expect(AppConfig).to receive(:new)
        govuk_pages = %w{ page1 page2 page3 }
        expect(YAML).to receive(:load_file).with(GOVUK_PAGES_FILE).and_return(govuk_pages)
        differ = double Differ
        expect(Differ).to receive(:new).and_return(differ)
        expect(differ).to receive(:diff).with('page1')
        expect(differ).to receive(:diff).with('page2')
        expect(differ).to receive(:diff).with('page3')

        Runner.new.run
      end
    end
  end
end
