require_relative 'test_helper'

require 'lib/bug'

class BugTest < Test::Unit::TestCase
  def test_get_fail
    VCR.use_cassette(__method__) do
      assert_raises(RuntimeError) do
        Bugzilla::Bug.get(123)
      end
    end
  end

  def test_get_success
    VCR.use_cassette(__method__) do
      bug = Bugzilla::Bug.get(359887)
      assert_equal('https://bugs.kde.org/show_bug.cgi?id=359887', bug.web_url)
    end
  end
end
