require 'app_config'
require_relative '../lib/page_searcher'
require_relative '../lib/root'
require_relative '../lib/app_config'

describe PageSearcher do
  describe '#pages' do
    it 'returns an array of the top four pages for each format' do
      config = AppConfig.new(File.dirname(__FILE__) + '/test_config.yml')
      searcher = PageSearcher.new(config, %w{ speech person })
      expect(searcher).to receive(:result_set_for_format).with('speech').and_return(speeches)
      expect(searcher).to receive(:result_set_for_format).with('person').and_return(people)
      expect(searcher.run).to eq expected_pages
    end

    def expected_pages
      %w{
        /government/speeches/spending-review
        /government/speeches/heathrow-expansion
        /government/speeches/welfare-reforms
        /government/peopel/chris-martin
        /government/peopel/david-cameron
        /government/peopel/nicky-morgan
        /government/peopel/george-osborne
      }
    end

    def speeches
      {
        'results' => [
          {
            'description' => 'The Spending Review and Autumn Statement speech in full.',
            'display_type' => 'Speech',
            'format' => 'speech',
            'link' =>  '/government/speeches/spending-review',
          },
          {
            'description' => 'Heathrow expansion speech',
            'display_type' => 'Speech',
            'format' => 'speech',
            'link' =>  '/government/speeches/heathrow-expansion',
          },
          {
            'description' => 'Welfare reforms (parameterised)',
            'display_type' => 'Speech',
            'format' => 'speech',
            'link' =>  '/government/speeches/welfare-reforms?universal_benefits=1',
          },
          {
            'description' => 'Welfare reforms',
            'display_type' => 'Speech',
            'format' => 'speech',
            'link' =>  '/government/speeches/welfare-reforms',
          }
        ]
      }.to_json
    end

    def people
      {
        'results' => [
          {
            'description' => 'Chris Martin',
            'link' =>  '/government/peopel/chris-martin',
          },
          {
            'description' => 'David Cameron',
            'link' =>  '/government/peopel/david-cameron',
          },
          {
            'description' => 'Nicky Morgan',
            'link' =>  '/government/peopel/nicky-morgan',
          },
          {
            'description' => 'George Osborne',
            'link' =>  '/government/peopel/george-osborne',
          },
          {
            'description' => 'Jeremy Hunt',
            'link' =>  '/government/peopel/jeremy-hunt',
          },
          {
            'description' => 'Michael Fallon',
            'link' =>  '/government/peopel/michael-fallon',
          },
          {
            'description' => 'Theresa May',
            'link' =>  '/government/peopel/theresa-may',
          },
        ]
      }.to_json
    end
  end
end
