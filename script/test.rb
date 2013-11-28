#!/usr/bin/env ruby
ENV['RACK_ENV'] = "test"
if ARGV[0] == 'features'
  test_dir = File.expand_path File.join(File.dirname(__FILE__), "..", "test/integration")
  test_files = Dir.glob(File.join(test_dir, "**", "*_feature.rb"))
else
  test_dir = File.expand_path File.join(File.dirname(__FILE__), "..", "test")
  test_files = Dir.glob(File.join(test_dir, "**", "*_spec.rb"))
end
test_files.each { |f| require f }
