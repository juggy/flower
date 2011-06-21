class Flower::Session
  attr_accessor :login_url, :email, :password,
    :cookie
  
  def initialize
    self.login_url = "https://www.flowdock.com/session"
    self.email     = ENV['EMAIL']
    self.password  = ENV['PASSWORD']
  end
  
  def login
    puts " Logging into the flow..."
    response = Typhoeus::Request.post(login_url,
      :params => {:user_session => {:email => email, :password => password}})
    self.cookie = response.headers_hash['Set-Cookie'].first
  end
  
  def get_json(url, params = {})
    response = Typhoeus::Request.get(url, :params => params,
      :headers => {:Cookie => cookie})
    JSON.parse(response.body)
  end
  
  def post(url, params)
    Typhoeus::Request.post("https://mynewsdesk.flowdock.com/messages", :params => params, :headers => {:Cookie => cookie})
  end
end