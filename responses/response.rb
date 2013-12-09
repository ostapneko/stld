class Response
  def initialize(status, body)
    @status = status
    @body   = body
  end

  attr_reader :status, :body
end
