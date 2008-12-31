require 'zeep'

class ZeepTest < Test::Unit::TestCase
  
  def setup
    @message = ZeepMessage.new("This is the message", 123)
  end
  
  def test_url
    assert_equal("https://api.zeepmobile.com/messaging/2008-07-14/send_message", @message.url)
  end
  
  def test_content_length
    assert_equal(36, @message.content_length)
  end
  
  def test_authorization_works
    assert_nothing_raised(Exception) { @message.authorization }
  end
  
  def test_show_request_works
    assert_nothing_raised(Exception) { @message.show_request }
  end
end