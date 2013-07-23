ENV['RACK_ENV'] = "test"
test_dir = File.expand_path File.join(File.dirname(__FILE__), "..", "test")
test_files = Dir.glob(File.join(test_dir, "**", "*_spec.rb"))
test_files.each { |f| require f }
