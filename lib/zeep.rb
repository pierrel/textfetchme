#  Created by Simon Wex (simon@zeepmobile.com) on 2008-07-12
#  Copyright (c) 2008. All rights reserved.
#  Released under MIT License

require 'openssl'
require 'base64'
require 'time'
require 'cgi'

class ZeepMessage
  @@API_KEY = 'cef7a046258082993759bade995b3ae8'
  @@SECRET_ACCESS_KEY = '19c87eb3e3a28404e7ea8197d4401540'
  @@ZEEP_URL = "https://api.zeepmobile.com/messaging/2008-07-14/send_message"
  
  def initialize(message, user_id)
    @message = message
    @user_id = user_id
    @date = Time.now.httpdate
  end
  
  def headers
    { "Authorization" => authorization,
      "Date" => @date,
      "Content-Type" => "application/x-www-form-urlencoded",
      "Content-Length" => content_length}
  end
  
  def parameters
    {:user_id => @user_id, :message => @message}
  end
  
  def url
    return @@ZEEP_URL
  end
    
  def content_length
    return (body).size
  end
  
  def body
    return "user_id=#{@user_id.to_s}&body=#{CGI.escape(@message)}"
  end
  
  def authorization
    # (ex. Sat, 12 Jul 2008 09:04:28 GMT)
    http_date =  @http_date

    parameters = body

    canonical_string = "#{@@API_KEY}#{http_date}#{parameters}"

    digest = OpenSSL::Digest::Digest.new('sha1')

    b64_mac = Base64.encode64(OpenSSL::HMAC.digest(digest, @@SECRET_ACCESS_KEY, canonical_string)).strip

    authentication = "Zeep #{@@API_KEY}:#{b64_mac}"

    return authentication
  end
  
  def show_request
    out = "POST /api/send_message HTTP/1.1\n"
    (headers).each_pair { |name, val| out = out + name.to_s + ": " + val.to_s + "\n" }
    (parameters).each_pair { |name, val| out = out + name.to_s + "=" + val.to_s + "&" }
    return out
  end
end