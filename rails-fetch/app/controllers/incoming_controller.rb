class IncomingController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def index
    if request.post? 
      render :text => "Hey #{User.find(params[:uid]).login}, you said #{params[:body]}", :status => 200, :content_type => 'text/plain'
    else
      render :text => "hello", :status => :ok, :content_type => 'text/plain'
    end
  end
end
