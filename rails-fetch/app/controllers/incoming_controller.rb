class IncomingController < ApplicationController
  skip_before_filter :verify_authenticity_token
  # TODO: Process SUBSCRIPTION_UPDATE events
  def index
    if request.post? 
      add_command = /add ([\w\d]+) (.+)/ # TODO: implement add command
      remove_command = /remove ([\w\d]+)/ # TODO: implement remove command
      body= params[:body].downcase
      user = User.find(params[:uid])
      if not user.nil?
        matching_trigger = user.trigger_with_key(params[:body])
        if matching_trigger.nil?
          text = "'#{params[:body]}' not found. These are your triggers: #{user.triggers.collect {|trigger| trigger.key }.join(", ")}."
        else
          text = matching_trigger.value
        end
      else
        render :text => "error, no user", :status => 400
      end
      render :text => text, :status => 200, :content_type => 'text/plain'
    end
  end
end
