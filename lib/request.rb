class Request
  attr_writer :post_data, :query, :http_method, :path, :headers, :content_length

  def initialize
    yield self if block_given?
  end

  def query
    @query ||= {}
  end

  def post_data
    @post_data ||= {}
  end

  def path
    @path ||= ""
  end

  def http_method
    @http_method ||= ""
  end

  def params
    @params ||= query.merge(post_data)
  end

  def info
    @info ||= http_method + " " + path
  end

  def headers
    @headers ||= {}
  end

  def cookies
    @cookies ||={}
  end

  def content_length
    @content_length ||= 0
  end

end