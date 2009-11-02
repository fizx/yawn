require "rubygems"
require "URI"
require "curl-multi"
require "thread"
class Yawn
  def initialize
    @curl = Curl::Multi.new
    @cv = ConditionVariable.new
    @mutex = Mutex.new
    @thread = Thread.new do
      @mutex.synchronize do
        loop do
          while @curl.size > 0
            @curl.select([], []) 
          end
          @cv.wait(@mutex)
        end
      end
    end
  end
  
  def get(url, &callback)
    callback ||= proc {}
    URI.parse(url)
    a = @curl.get(url, callback, callback)
    @mutex.synchronize { @cv.signal }
    a
  end
  
  def post(url, data, &callback)
    callback ||= proc {}
    URI.parse(url)
    a = @curl.post(url, data, callback, callback)
    @mutex.synchronize { @cv.signal }
    a
  end
end