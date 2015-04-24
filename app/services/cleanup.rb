class Cleanup
  include HTTParty
  attr_accessor :host

  def initialize(host="http://localhost:8080")
    @host=host
  end

  def url(page)
    "#{@host}/content?url=#{page}"
  end

  def clean(page)
    self.class.get(url(page))
  end
end
