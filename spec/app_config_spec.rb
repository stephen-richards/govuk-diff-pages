require_relative '../lib/app_config'

describe AppConfig do
  let(:test_config_file) { File.dirname(__FILE__) + '/test1.yml' }
  let(:config)  { AppConfig.new(test_config_file) }

  it 'loads the config' do
    expect(config.app_name).to eq 'app_config'
    expect(config.app_lang).to eq 'ruby'
    expect(config.array).to eq %w{ one two three }
    expect(config.my_hash).to be_instance_of(AppConfig)
    expect(config.my_hash.key1).to eq 'value1'
    expect(config.my_hash.key2).to eq 'value2'
    expect(config.my_hash.key3).to be_instance_of(AppConfig)
    expect(config.my_hash.key3.nested_key1).to eq 'nested_value1'
    expect(config.my_hash.key3.nested_key2).to eq 'nested_value2'
  end

  it 'returns nil for values loaded from the yaml file as nil' do
    expect(config.key_with_nil_value).to be_nil
  end

  it 'returns nil for nested keys in the yaml file as nil' do
    expect(config.nested.key_with_nil_value).to be_nil
  end

  it 'raises an error for a non existent key' do
    expect {
      config.no_such_key
    }.to raise_error AppConfig::MissingKeyError, "No such config key 'no_such_key'"
  end

  it 'raises an error for a non-existent nested key' do
    expect {
      config.nested.no_such_nested_key
    }.to raise_error AppConfig::MissingKeyError, "No such config key 'no_such_nested_key'"
  end

  describe 'to_h' do
    it 'produces a hash with string keys for the entire file' do
      hash = config.to_h
      expect(hash).to eq(YAML.load_file(test_config_file))
    end

    it 'produces a hash with string keys for a section of the file' do
      hash = config.my_hash.to_h
      expect(hash).to eq(YAML.load_file(test_config_file)['my_hash'])
    end
  end
end
