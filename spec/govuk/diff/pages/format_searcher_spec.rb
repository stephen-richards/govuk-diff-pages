describe Govuk::Diff::Pages::FormatSearcher do
  describe '#run' do
    it 'returns and array of formats' do
      SEARCH_API_RESPONSE = {
       "facets" =>
        { "format" =>
          { "options" =>
            [{ "value" => { "slug" => "publication" }, "documents" => 81996 },
             { "value" => { "slug" => "news_article" }, "documents" => 44322 },
             { "value" => { "slug" => "aaib_report" }, "documents" => 9735 },
             { "value" => { "slug" => "world_location_news_article" }, "documents" => 8827 },
             ],
           "documents_with_no_value" => 0,
           "total_options" => 58,
           "missing_options" => 0,
           "scope" => "exclude_field_filter" } },
       "suggested_queries" => []
      }.to_json
      config = Govuk::Diff::Pages::AppConfig.new(File.dirname(__FILE__) + '/../../../test_config.yml')
      searcher = described_class.new(config)
      expect(searcher).to receive(:get_facets).and_return(SEARCH_API_RESPONSE)
      expect(searcher.run).to eq(%w{ publication news_article aaib_report world_location_news_article })
    end
  end
end
