require 'uri'
require 'eventmachine'
require 'evma_httpserver'

require_relative 'current_time'
require_relative 'current_time_response'

# HTTP server
class TimeServer < EM::Connection
  include EM::HttpServer

  def process_http_request
    if @http_request_method == 'GET' && @http_request_uri == '/time'
      process_time_request
    else
      send_response_404
    end
  end

  def process_time_request
    current_time = CurrentTime.new
    response = CurrentTimeResponse.new(current_time, cities)
    send_response(response.build)
  end

  private

  def cities
    return [] unless @http_query_string
    URI.unescape(@http_query_string).split(',').map(&:strip).reject(&:empty?)
  end

  def send_response_404
    send_response('Not found', 404)
  end

  def send_response(content, status = 200)
    response = EM::DelegatedHttpResponse.new(self)
    response.content_type('text/plain')
    response.status = status
    response.content = content
    response.send_response
  end
end

EM.run do
  EM.start_server('127.0.0.1', 8181, TimeServer)
end
