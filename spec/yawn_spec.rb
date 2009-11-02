require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Yawn" do
  before do
    @yawn = Yawn.new
  end
  
  it "should respond to get" do
    @yawn.get("http://google.com/")
  end
  
  it "should respond to post" do
    @yawn.post("http://google.com/", "data")
  end
  
  it "should take a handler" do
    @yawn.get("http://www.google.com/") do |response|
      @response = response
    end
    sleep 1
    @response.should_not be_empty
  end
  
  it "should raise on invalid url" do
    proc {
      @yawn.get("http:/\\")
    }.should raise_error(URI::InvalidURIError)
  end
  
end
