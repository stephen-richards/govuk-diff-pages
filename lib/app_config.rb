require 'yaml'
require 'ostruct'
require_relative 'root'

class AppConfig
  class MissingKeyError < RuntimeError; end

  # param can be one of the following:
  # * a file path - the config will be loaded from the specified yaml file
  # * a Hash - the config will be loaded directly from the hash,
  # * nil - the config will be loaded from the default yaml file (config/settings.yml)
  #
  def initialize(path_or_hash = nil)
    if path_or_hash.is_a?(Hash)
      @config = populate_config(path_or_hash)
    else
      path_or_hash ||= "#{ROOT_DIR}/config/settings.yml"
      hash = YAML.load_file(path_or_hash)
      @config = populate_config(hash)
    end
  end

  def method_missing(method, *_params)
    result = @config.public_send(method)
    raise MissingKeyError.new "No such config key '#{method}'" if result.nil?
    result = nil if result == :nil_value
    result
  end

  def to_h
    result = {}
    @config.to_h.each do |key, value|
      value = nil if value == :nil_value
      if value.is_a?(AppConfig)
        result[key.to_s] = value.to_h
      else
        result[key.to_s] = value
      end
    end
    result
  end

private
  def populate_config(hash)
    config = OpenStruct.new
    hash.each do |key, value|
      if value.is_a?(Hash)
        config[key] = AppConfig.new(value)
      else
        value = :nil_value if value.nil?
        config[key] = value
      end
    end
    config
  end
end
