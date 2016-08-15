# encoding: utf-8

require(File.expand_path('test_helper', File.dirname(__FILE__)))

# Dud base class. We mocha this for functionality later.
class Plugin
  def map(*args)
  end
end

require 'bugzilla'

class PluginTest < Test::Unit::TestCase

  # NB: mocha is stupid with the quotes and can't tell single from double!

  def message_double
    channel = mock('message-channel')
    channel.stubs(:name).returns('#message-double-channel')
    mock('message').tap { |m| m.stubs(:channel).returns(channel) }
  end

  def test_get_unreplied
    message = message_double
    message.stubs(:message).returns('yolo brooom bug 123')

    plugin = BugzillaPlugin.new
    plugin.expects(:bug).with(message, number: '123')
    plugin.unreplied(message)
  end

  def test_bug
    message = message_double
    message.expects(:reply).with('KDE bug 359887 in neon (general) "Neon packages change DISTRIB_ID in /etc/lsb-release" [normal,FIXED] https://bugs.kde.org/show_bug.cgi?id=359887')

    VCR.use_cassette(__method__) do
      plugin = BugzillaPlugin.new
      plugin.bug(message, { :number => 359887 })
    end
  end

  def test_bug_fail
    message = message_double
    message.expects(:notify).with('Bug not found (ノಠ益ಠ)ノ彡┻━┻ JSONError {:message=>"Bug #1 does not exist.", :code=>101}')

    VCR.use_cassette(__method__) do
      plugin = BugzillaPlugin.new
      plugin.bug(message, { :number => 1 })
    end
  end

  def test_get_unreplied_multi_match
    message = message_double
    message.stubs(:message).returns('yolo brooom bug 123 and bug 321')

    plugin = BugzillaPlugin.new
    plugin.expects(:bug).with(message, number: '123')
    plugin.expects(:bug).with(message, number: '321')
    plugin.unreplied(message)
  end

  def test_get_unreplied_multi_match_url
    message = message_double
    message.stubs(:message).returns('yolo brooom https://bugs.kde.org/show_bug.cgi?id=366701 and https://bugs.kde.org/show_bug.cgi?id=366702')

    plugin = BugzillaPlugin.new
    plugin.expects(:bug).with(message, number: '366701')
    plugin.expects(:bug).with(message, number: '366702')
    plugin.unreplied(message)
  end

  def test_skip
    message = message_double
    message.channel.stubs(:name).returns('#kde-bugs-activity')
    plugin = BugzillaPlugin.new
    plugin.unreplied(message)
  end
end
