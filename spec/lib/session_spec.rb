require 'spec_helper'

describe Flower::Session do
  before do
    @session = Flower::Session.new
    Typhoeus::Hydra.hydra.clear_stubs
  end

  describe "#new" do
    it "should set attributes" do
      @session.login_url.should == "https://www.flowdock.com/session"
      @session.email.should_not be_empty
      @session.password.should_not be_empty
    end
  end

  describe "#login" do
    it "should set cookie attribute if login is successful" do
      stub_login_response(302)
      lambda{
        @session.login
      }.should change{@session.cookie}.from(nil).to(String)
    end

    it "should exit program if login failed" do
      stub_login_response(200)
      lambda{
        @session.login
      }.should raise_error SystemExit
    end
  end

  describe "#get_json" do
    it "should return the parsed JSON response body" do
      response = Typhoeus::Response.new(:code => 200, :body => '{"foo": "1", "bar": 2}')
      Typhoeus::Hydra.hydra.stub(:get, "www.foodock.com?").and_return(response) # '?' - ?!

      json = @session.get_json("www.foodock.com")
      json.should == {"foo" => "1", "bar" => 2}
    end
  end

  describe "#post" do
    it "should post the given params" do
      response = Typhoeus::Response.new(:code => 200)
      Typhoeus::Hydra.hydra.stub(:post, "www.foodock.com").and_return(response)
      @session.post("www.foodock.com", {:foo => "bar"}).should be_nil
    end
  end

  def stub_login_response(code)
    response = if code == 302
      response_headers = File.read(File.join(File.dirname(__FILE__), "..", "http_responses", "302_login_response_headers.txt"))
      Typhoeus::Response.new(:code => 302, :headers => response_headers)
    else
      Typhoeus::Response.new(:code => 200)
    end
    Typhoeus::Hydra.hydra.stub(:post, "https://www.flowdock.com/session").and_return(response)
  end
end
