#!/usr/bin/env ruby

# This is a fancy wrapper around test_helper to prevent the collector from
# loading the helper twice as it would occur if we ran the helper directly.
require(File.expand_path('test_helper', File.dirname(__FILE__)))

Test::Unit::AutoRunner.run(true, File.absolute_path(__dir__))
