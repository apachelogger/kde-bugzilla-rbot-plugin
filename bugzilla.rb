# encoding: utf-8
# frozen_string_literal: true
#
# Copyright (C) 2016 Harald Sitter <sitter@kde.org>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 3 of
# the License or any later version accepted by the membership of
# KDE e.V. (or its successor approved by the membership of KDE
# e.V.), which shall act as a proxy defined in Section 14 of
# version 3 of the license.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require(File.expand_path('lib/bug', File.dirname(__FILE__)))

# Bugzilla Plugin
class BugzillaPlugin < Plugin
  def unreplied(m, _ = {})
    return if skip?(m)
    # Bot by default only handles messages directed at it directly by either
    # its name or a shortcut prefix. For the bug plugin we additionally want
    # to handle casual conversation to give context.
    match = m.message.scan(/\bbug\s+(\d+)\b/i)
    if match.empty?
      # Attempt ot match URL.
      match = m.message.scan(%r{\bhttps://bugs\.kde\.(?:[^\s]+)=(\d+)\b}i)
    end
    match.flatten.each do |number|
      bug(m, {:number => number})
    end
  end

  def bug(m, options = {})
    number = options.fetch(:number)
    bug = Bugzilla::Bug.get(number)
    m.reply "KDE bug #{bug.id} in #{bug.product} (#{bug.component}) \"#{bug.summary}\" [#{bug.severity},#{bug.resolution}] #{bug.web_url}"
  rescue => e
    m.notify "Bug not found (ノಠ益ಠ)ノ彡┻━┻ #{e}"
  end

  private

  def skip?(m)
    %w(#kde-bugs-activity).any? do |exclude|
      m.channel && m.channel.name == exclude
    end
  end
end

plugin = BugzillaPlugin.new
plugin.map 'bug :number',
  requirements: {
    number: /^[^ ]+$/
  },
  action: 'bug',
  thread: 'yes'
  # , auth_path: 'view'
