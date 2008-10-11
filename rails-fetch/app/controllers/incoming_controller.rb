require 'overrides'

class IncomingController < ApplicationController
  skip_before_filter :verify_authenticity_token
  # TODO: Process SUBSCRIPTION_UPDATE events
  
  def index
    staus = 200
    reserved_words = ['add', 'remove', 'help', 'triggers']
    if request.post?
      if params[:event] == 'SUBSCRITION_UPDATE'
        begin
          User.find(params[:uid])
          text = 'Welcome to TextFetchMe!'
        rescue ActiveRecord::RecordNotFound => e
          text = 'User does not exist'
          status = :missing
        end
      elsif not params[:body].nil?
        add_command = /^add ([\w\d]+)(| [\w\d]+)$/ # TODO: implement add command
        remove_command = /^remove ([\w\d]+)/ # TODO: implement remove command
        user = User.find(params[:uid])
        body = params[:body]
        if not user.nil?
          if reserved_words.include? body
            add_match, remove_match  = body.match(add_command), body.match(remove_command)
            if add_match
              user.add_trigger(:key => add_match[1], :value => add_match[2].strip)
              text = user.trigger_with_key(add_match[1])
            elsif remove_match
              user.remove_trigger(remove_match[1])
              text = "removed trigger '#{remove_match[1]}'"
            else
              text = "'#{params[:body]}' not found. These are your triggers: #{user.trigger_keys.join(", ")}." 
            end
          else
            matching_trigger = user.trigger_with_key(params[:body])
            if matching_trigger.nil?
              text = "'#{params[:body]}' not found. These are your triggers: #{user.trigger_keys.join(", ")}."
            else
              text = matching_trigger.value
            end
          end
        else
          render :text => "error, no user", :status => 400
        end
      end
      render :text => text, :status => status, :content_type => 'text/plain'
    end
  end  
end
