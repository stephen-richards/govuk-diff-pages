RSpec.describe Govuk::Diff::Pages::TextDiff::Formatter do
  describe '#call' do
    it 'strips HTML from the given argument and returns plain text' do
      {
        %(<html><body>abcd</body></html>)       => 'abcd',
        %(<a href="http://google.com">whoa</a>) => 'whoa',
        %(abc efgh ijkl)                        => 'abc efgh ijkl',
        %(<a>malformed html whoops)             => 'malformed html whoops',
      }.each do |html, text|
        expect(described_class.new.call(html)).to eq(text)
      end
    end
  end
end
