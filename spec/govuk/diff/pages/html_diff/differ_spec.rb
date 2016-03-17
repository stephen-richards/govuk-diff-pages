describe Govuk::Diff::Pages::HtmlDiff::Differ do
  after(:all) do
    test_output_dir = "#{Govuk::Diff::Pages.root_dir}/html_diff_dir"
    FileUtils.rm_r test_output_dir, secure: true if Dir.exist?(test_output_dir)
  end

  let(:config) {
    double(:AppConfig,
      domains: double('domains',
        production: 'https://www.gov.uk',
        staging: 'https://staging.gov.uk'),
      html_diff: double('html_diff',
        directory: 'html_diff_dir'))
  }
  let(:differ) { described_class.new(config) }
  let(:target_base_path) { '/my_base_path' }
  let(:production_url) { "https://www.gov.uk/my_base_path" }
  let(:staging_url) { "https://staging.gov.uk/my_base_path" }

  describe '#diff' do
    context 'getting and normalizing the html' do
      it 'gets html for production and staging domains for the url' do
        expect(differ).to receive(:fetch_html).with(production_url).and_return(production_html)
        expect(differ).to receive(:fetch_html).with(staging_url).and_return(staging_html)
        differ.diff(target_base_path)
      end

      it 'returns just the body and replaces the filters' do
        expect(differ).to receive(:fetch_html).with(staging_url).and_return(staging_html)
        normalized_html = differ.send(:get_normalized_html, staging_url)
        expect(squish(normalized_html)).to eq staging_normalized_html
      end
    end

    it 'calls diffy on the two sets of html' do
      expect(differ).to receive(:get_normalized_html).with(staging_url).and_return(staging_normalized_html)
      expect(differ).to receive(:get_normalized_html).with(production_url).and_return(staging_normalized_html)
      diffy = double Diffy::Diff
      expect(Diffy::Diff).to receive(:new).with(staging_normalized_html, staging_normalized_html, context: 3).and_return(diffy)
      expect(diffy).to receive(:to_s).with(:html).and_return('')
      allow(diffy).to receive(:diff)

      differ.diff(target_base_path)
    end

    context 'html is the same' do
      before(:each) do
        expect(differ).to receive(:get_normalized_html).with(staging_url).and_return('<body>abcd</body>')
        expect(differ).to receive(:get_normalized_html).with(production_url).and_return('<body>abcd</body>')
      end
      it 'does not write an html_diff file' do
        expect(differ).not_to receive(:write_diff_page)
        differ.diff(target_base_path)
      end

      it 'does not add the base path to the list of differing pages' do
        expect(differ).not_to receive(:write_diff_page)
        differ.diff(target_base_path)
        expect(differ.differing_pages).to be_empty
      end
    end

    context 'html is different' do
      before(:each) do
        expect(differ).to receive(:get_normalized_html).with(staging_url).and_return('<body>abcd</body>')
        expect(differ).to receive(:get_normalized_html).with(production_url).and_return('<body>xxx</body>')
      end

      it 'writes an html diff file' do
        expect(differ).to receive(:write_diff_page).with(target_base_path, instance_of(String))
        differ.diff(target_base_path)
      end

      it 'adds the base path to the list of differing pages' do
        expect(differ).to receive(:write_diff_page).with(target_base_path, instance_of(String))
        differ.diff(target_base_path)
        expect(differ.differing_pages).to eq(target_base_path => "#{Govuk::Diff::Pages.root_dir}/html_diff_dir/my_base_path.html")
      end
    end
  end

  def production_html
    squish(
      '<html>
        <head>
          <title>Production</title>
        </head>
        <body>
          <a href="https://www.gov.uk" title="Go to the GOV.UK homepage" id="logo" class="content">
            <img src="https:///static/gov.uk_crown.png" width="35" height="31" alt=""> GOV.UK
          </a>
        </body>
      </html>')
  end


  def staging_html
    squish(
      '<html>
        <head>
          <title>Staging Title</title>
        </head>
        <body>
          <a href="https://www-origin.staging.publishing.service.gov.uk" title="Go to the GOV.UK homepage" id="logo" class="content">
            <img src="https://assets-origin.staging.publishing.service.gov.uk/static/gov.uk_crown.png" width="35" height="31" alt="">
            GOV.UK
          </a>
          <p>This is the staging body</p>
        </body>
      </html>')
  end

  def staging_normalized_html
    squish(
      '<body>
          <a href="https://www.gov.uk" title="Go to the GOV.UK homepage" id="logo" class="content">
            <img src="https://assets.digital.cabinet-office.gov.uk/static/gov.uk_crown.png" width="35" height="31" alt="">
            GOV.UK
          </a>
          <p>This is the staging body</p>
        </body>')
  end

  def squish(html)
    html.delete("\n").gsub(/>\s+/, '>').gsub(/\s+</, '<')
  end

  describe '#html_diff_file_name' do
    it 'makes valid filename in html diff directory' do
      base_path = '/my_base_path/subdir'
      expect(differ.send(:html_diff_filename, base_path)).to eq "#{Govuk::Diff::Pages.root_dir}/html_diff_dir/my_base_path.subdir.html"
    end

    it 'makes valid filename in html diff directory when trailing slash present' do
      base_path = '/my_base_path/subdir/'
      expect(differ.send(:html_diff_filename, base_path)).to eq "#{Govuk::Diff::Pages.root_dir}/html_diff_dir/my_base_path.subdir.html"
    end
  end
end
