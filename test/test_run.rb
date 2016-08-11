# This is a fancy wrapper around test_helper to prevent the collector from
# loading the helper twice as it would occur if we ran the helper directly.
require_relative 'test_helper'

Test::Unit::AutoRunner.run(true, File.absolute_path(__dir__))
