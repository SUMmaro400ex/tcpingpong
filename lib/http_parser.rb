class EmptyRequestError < RuntimeError; end

class HttpParser
  require 'rack'
  attr_reader :raw_request, :first_line

  CARRIAGE_RETURN = "\r\n".freeze

  def parse request_socket
    @raw_request = request_socket
    @first_line = raw_request.gets || raise(EmptyRequestError)
    Request.new do |r|
      r.http_method = http_method
      r.path = path
      r.headers = headers
      r.content_length = content_length
      r.post_data = read_body
    end
  end

  private

  def http_method
    @http_method ||= first_line.split.first
  end

  def has_body?
    !["GET", "DELETE"].include? http_method
  end

  def path
    @path ||= first_line.split(' ')[1].split('?')[0]
  end

  def headers
    @header ||= parse_headers
  end

  def parse_headers
    set_lines
    lines.each_with_object({}) do |line, request_headers|
      key, val = line.split(/:\s/)
      request_headers[key] = val.to_s.chomp
    end
  end

  def lines
    @lines ||= []
  end

  def set_lines
    while (line = raw_request.gets) != CARRIAGE_RETURN
      lines << line.chomp
    end
  end

  def content_length
    headers['Content-length'].to_i
  end

  def read_body
    Rack::Utils.parse_nested_query(raw_request.read(content_length)) if has_body?
  end

end