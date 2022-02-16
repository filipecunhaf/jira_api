require 'excon'
require 'json'
require 'curb'

class JiraAPI
  Excon.defaults[:ssl_verify_peer] = false
  # This class should be used to in all requests classes

  class Request
    attr_accessor :url, :headers

    @headers = {
      'User-Agent' => 'Mozilla/5.0 (Linux x86_64)',
      'Content-Type' => 'application/json'
    }

    # def initialize( uri )
    #   @url = URI.parse( uri ).to_s
    # end
    @@connection = nil

    def self.url=(uri)
      @url = URI.parse(uri).to_s
    end

    def self.url
      @url ||= ''
    end

    class << self
      attr_reader :headers
    end

    def self.get(path = nil, payload = nil, query = nil, headers = nil)
      http_request(:get, path, payload, query, headers)
    end

    def self.post(path = nil, payload = nil, query = nil, headers = nil)
      http_request(:post, path, payload, query, headers)
    end

    def self.put(path = nil, payload = nil, query = nil, headers = nil)
      http_request(:put, path, payload, query, headers)
    end

    def self.delete(path = nil, payload = nil, query = nil, headers = nil)
      http_request(:delete, path, payload, query, headers)
    end

    def self.http_request(method = :get, path, payload, query, headers)
      # puts @url.inspect
      _headers = headers || @headers
      connection = Excon.new(@url)
      # puts payload.inspect
      body = payload ? payload.to_json : ''
      options = {
        method: method,
        # proxy: 'http://127.0.0.1:8081',
        path: path,
        body: body,
        query: query,
        headers: _headers,
        expects: [200, 201, 204, 400, 401, 500],
        read_timeout: 360,
        # persistent: true,
        # idempotent: true,
        # retry_limit: 2,
        # retry_interval: 10,
        # debug_response: true,
        # debug_request: true,
        tcp_nodelay: true
      }
      # puts options.inspect
      # return
      connection.request(options)
      # puts response.class

      # return response.body if response.body.length > 0
    end
  end
end
