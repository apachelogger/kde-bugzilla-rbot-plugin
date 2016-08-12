begin
  require 'simplecov'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::HTMLFormatter
    ]
  )
  SimpleCov.start
rescue LoadError
  warn 'SimpleCov not loaded'
end

def __dir__
  File.dirname(File.realpath(__FILE__))
end

require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = "#{__dir__}/fixtures/vcr_casettes"
  config.hook_into :webmock
end

$LOAD_PATH.unshift(File.absolute_path('../', __dir__)) # ../
$LOAD_PATH.unshift(File.absolute_path(__dir__)) # test/

require 'test/unit'
require 'mocha/test_unit' # Patch mocha in
require 'mocha/setup' # Make sure it is set up (ruby 1.9)
