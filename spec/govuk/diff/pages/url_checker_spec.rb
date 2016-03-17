describe Govuk::Diff::Pages::UrlChecker do
  let(:config) { double(:AppConfig, domains: double('domains', production: 'https://www.gov.uk')) }
  let(:checker) { described_class.new(config) }

  describe '#valid?' do
    it 'rejects a full url with a prameter in it' do
      expect(checker.valid?('https://www.gov.uk/reports?date=1985')).to be false
    end

    it 'rejects a relative path with a parameter' do
      expect(checker.valid?('/reports?date=1985')).to be false
    end

    it 'rejects anything from another domain' do
      expect(checker.valid?('https://www.goggle.com/benefits')).to be false
    end

    it 'accepts relative paths' do
      expect(checker.valid?('/benefits/child-benefit')).to be true
    end

    it 'accepts full paths' do
      expect(checker.valid?('https://www.gov.uk/benefits/child-benefit')).to be true
    end
  end

  describe '#normalize' do
    it 'raises if not a govuk url' do
      expect {
        checker.normalize('https://www.google.com/benefits')
      }.to raise_error RuntimeError, 'Not GOVUK url: https://www.google.com/benefits'
    end

    it 'returns a govuk url stripped of its base' do
      expect(checker.normalize('https://www.gov.uk/benefits/child-benefit')).to eq '/benefits/child-benefit'
    end

    it 'returns a relative url as-is' do
      expect(checker.normalize('/benefits/child-benefit')).to eq '/benefits/child-benefit'
    end
  end
end
