RSpec.describe Govuk::Diff::Pages::TextDiff::Runner do
  let(:pages) { %w(a) }
  let(:retriever) { double }
  let(:formatter) { double }
  let(:renderer) { double }

  before do
    allow(retriever).to receive(:call).with(/www-origin.publishing/).and_return('<h1>Tiny Rick</h1>')
    allow(retriever).to receive(:call).with(/www-origin.staging/).and_return('<h1>Tiny</h1>')
    allow(renderer).to receive(:call)
  end

  describe '#run' do
    context 'for each given page' do
      it 'retrieves the staging and production HTML' do
        expect(retriever).to receive(:call).with(/www-origin.publishing/).and_return('<h1>Tiny Rick</h1>')
        expect(retriever).to receive(:call).with(/www-origin.staging/).and_return('<h1>Tiny</h1>')

        described_class.new(pages: pages, retriever: retriever, renderer: renderer).run
      end

      it 'strips HTML and returns the plain text' do
        expect(formatter).to receive(:call).with('<h1>Tiny Rick</h1>').and_return('Tiny Rick')
        expect(formatter).to receive(:call).with('<h1>Tiny</h1>').and_return('Tiny')

        described_class.new(pages: pages, retriever: retriever, formatter: formatter, renderer: renderer).run
      end

      it 'calls the renderer' do
        expect(renderer).to receive(:call)

        described_class.new(pages: pages, retriever: retriever, renderer: renderer).run
      end
    end
  end
end
