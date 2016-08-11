require_relative 'test_helper'

# Dud base class. We mocha this for functionality later.
class Plugin
  def map(*args, **kwords)
  end
end

require 'bugzilla'

class PluginTest < Test::Unit::TestCase

  # NB: mocha is stupid with the quotes and can't tell single from double!

  def test_get_unreplied
    message = mock('message')
    message.stubs(:message).returns('yolo brooom bug 123')

    plugin = BugzillaPlugin.new
    plugin.expects(:bug).with(message, number: '123')
    plugin.unreplied(message)
  end

  def test_bug
    message = mock('message')
    message.expects(:reply).with('KDE bug 359887 in neon (general) "Neon packages change DISTRIB_ID in /etc/lsb-release" [normal,FIXED] https://bugs.kde.org/show_bug.cgi?id=359887')

    VCR.use_cassette(__method__) do
      plugin = BugzillaPlugin.new
      plugin.bug(message, number: 359887)
    end
  end

  def test_bug_fail
    message = mock('message')
    message.expects(:notify).with('Bug not found (ノಠ益ಠ)ノ彡┻━┻ JSONError {:message=>"Bug #1 does not exist.", :code=>101}')

    VCR.use_cassette(__method__) do
      plugin = BugzillaPlugin.new
      plugin.bug(message, number: 1)
    end
  end
end
