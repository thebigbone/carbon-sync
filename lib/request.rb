require 'net/http'
require 'uri'
require 'json'

class Request
  attr_accessor :response

  def initialize(url)
    @url = url
    @uri = URI(@url)
  end

  def headerRequest
    Net::HTTP.start(@uri.host, @uri.port, use_ssl: @uri.scheme == 'https') do |http|
      request = Net::HTTP::Post.new(@uri, 'Content-Type' => 'application/json')
      request.body = { password: ENV['PIHOLE_PASSWORD'] }.to_json
      response = http.request(request)
      response
    end
  end

  def checkAuth(sid)
    Net::HTTP.start(@uri.host, @uri.port, use_ssl: @uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new(@uri)
      request['sid'] = sid
      response = http.request(request)
      response
    end
  end
end
