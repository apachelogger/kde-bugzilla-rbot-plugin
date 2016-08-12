# frozen_string_literal: true
#
# Copyright (C) 2016 Harald Sitter <sitter@kde.org>
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) version 3, or any
# later version accepted by the membership of KDE e.V. (or its
# successor approved by the membership of KDE e.V.), which shall
# act as a proxy defined in Section 6 of version 3 of the license.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library.  If not, see <http://www.gnu.org/licenses/>.

require 'faraday'
require 'json'
require 'uri'
require 'logger'

require_relative 'representation'

module Bugzilla
  # Connection logic wrapper.
  class Connection
    attr_accessor :uri

    # FinerStruct wrapper around jsonrpc returned hash.
    class JSONRepsonse < FinerStruct::Immutable
      def initialize(response)
        super(JSON.parse(response.body, symbolize_names: true))
      end
    end

    def initialize
      @uri = URI.parse('https://bugs.kde.org')
    end

    def call(meth, kwords = {})
      response = get(meth, kwords)
      raise "HTTPError #{response.status}" if response.status != 200
      response = JSONRepsonse.new(response)
      raise "JSONError #{response.error}" if response.error
      response.result
    end

    private

    def get(meth, kwords = {})
      client.get do |req|
        req.url '/jsonrpc.cgi'
        req.headers['Content-Type'] = 'application/json'
        req.params = {
          method: meth,
          params: [kwords].to_json
        }
      end
    end

    def client
      @client ||= Faraday.new(@uri.to_s) do |faraday|
        faraday.request :url_encoded
        # faraday.response :logger, ::Logger.new(STDOUT), bodies: true
        faraday.adapter Faraday.default_adapter
      end
    end
  end
end
