RSpec.describe Govuk::Diff::Pages::TextDiff::Renderer do
  context 'with empty diffs' do
    it 'puts an OK message to STDOUT' do
      expect { described_class.new.call(['']) }.to output("OK!\n").to_stdout
    end
  end

  context 'with diffs' do
    let(:kernel) { double }

    it 'aborts with the diffs to STDERR' do
      expect(kernel).to receive(:abort).with(an_instance_of(String))

      described_class.new(kernel).call(["-meh\n+beh\n"])
    end
  end
end
