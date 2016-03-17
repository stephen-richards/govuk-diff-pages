require "rspec/core/rake_task"
require "gem_publisher"

load File.dirname(__FILE__) + "/lib/govuk/diff/pages/tasks/rakefile.rake"

RSpec::Core::RakeTask.new(:spec)
task default: :spec

task :publish_gem do
  gem = GemPublisher.publish_if_updated("govuk-diff-pages.gemspec", :rubygems)
  puts "Published #{gem}" if gem
end
