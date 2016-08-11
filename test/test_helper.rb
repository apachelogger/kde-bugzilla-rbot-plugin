
require 'simplecov'
SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
  [
    SimpleCov::Formatter::HTMLFormatter
  ]
)
SimpleCov.start

require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = "#{__dir__}/fixtures/vcr_casettes"
  config.hook_into :webmock
end

$LOAD_PATH.unshift(File.absolute_path('../', __dir__)) # ../
$LOAD_PATH.unshift(File.absolute_path(__dir__)) # test/

require 'test/unit'
require 'mocha/test_unit' # Patch mocha in
