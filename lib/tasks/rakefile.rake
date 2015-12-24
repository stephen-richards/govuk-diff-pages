
namespace :diff do
  desc 'produce visual diffs'
  task visual: ['config:pre_flight_check'] do
    puts "---> Creating Visual Diffs"
    require_relative '../root'
    cmd = "wraith capture #{ROOT_DIR}/config/wraith.yaml"
    puts cmd
    system cmd
  end

  desc 'produce html diffs'
  task :html do
    require_relative '../html_diff/runner'
    HtmlDiff::Runner.new.run
  end
end

namespace :config do
  desc "Checks that dependencies are in place"
  task :pre_flight_check do
    puts "Checking required packages installed."
    dependencies_present = true
    {imagemagick: 'convert', phantomjs: 'phantomjs'}.each do |package, binary|
      print "#{package}..... "
      result = %x[ which #{binary} ]
      if result.empty?
        puts "Not found"
        dependencies_present = false
      else
        puts "OK"
      end
    end
    unless dependencies_present
      puts "ERROR: A required dependency is not installed"
      exit 1
    end
  end

  desc 'merges settings.yml with govuk_pages.yml to produce merged config file for wraith'
  task :wraith do
    puts "---> Generating Wraith config"
    require_relative '../wraith_config_generator'
    generator = WraithConfigGenerator.new
    generator.run
    generator.save
  end

  desc 'update config files with list of pages to diff'
  task :update_page_list do
    puts "---> Updating page list"
    require_relative '../page_indexer'
    PageIndexer.new.run
  end
end

namespace :shots do
  desc "clears the screen shots directory"
  task :clear do
    puts "---> Clearing shots directory"
    require_relative '../app_config'
    require_relative '../root'
    require 'fileutils'
    config = AppConfig.new
    [config.wraith.directory, config.html_diff.directory].each do |directory|
      shots_dir = "#{ROOT_DIR}/#{directory}"
      FileUtils.remove_dir shots_dir
    end
  end
end

desc 'Generate config files and run diffs'
task diff: ['config:update_page_list', 'config:wraith', 'diff:visual', 'diff:html']

desc 'checks all URLs are accessible'
task :check_urls do
  require_relative '../link_checker'
  LinkChecker.new.run
end

task :spec do
  require_relative '../root'
  system "rspec #{ROOT_DIR}/spec"
end
