require 'overrides'

class IncomingController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def index
    trigger = "'fetchme trigger' will text you the information associated with trigger 'trigger'\n"
    add = "'fetchme add trigger info' will add 'info' to the end of the information assiciated with trigger 'trigger'\n"
    remove = "'fetchme remove trigger' will remove the trigger 'trigger' from your account"
    help = trigger + " " + add + " " + remove
    staus = 200
    reserved_words = ['help', 'triggers']
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
        add_command = /^add ([\w\d]+)(| .+)$/
        remove_command = /^remove ([\w\d]+)/
        user = User.find(params[:uid])
        body = params[:body]
        add_match, remove_match  = body.match(add_command), body.match(remove_command)
        if not user.nil?
          if body == 'triggers'
            text = user.trigger_keys.join(", ")
          elsif body == 'help'
            text = help
          elsif add_match
            begin
              user.add_trigger(:key => add_match[1], :value => add_match[2].strip)
              text = "added '#{add_match[1]}' as '#{user.trigger_with_key(add_match[1]).value}'"
            rescue NoTriggersAvailable => e
              text = "All available triggers are being used, remove one to add another."
            end
          elsif remove_match
            begin
              user.remove_trigger(remove_match[1])
              text = "removed trigger '#{remove_match[1]}'"
            rescue NoTriggerToRemove => e
              text = "No trigger called '#{remove_match[1]}'"
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
      # TODO: split text into 410-character strings and send one at a time
      split_text = text.divide(410)
      first_message = split_text.shift
      render :text => first_message, :status => status, :content_type => 'text/plain'
      send_messages_serial(split_text, user.id)
    end
  end
  
  private
  def send_messages_serial(messages, id)
    messages.each do |message|
      zeep_message = ZeepMessage.new(message, id)
      post zeep_message.url, zeep_message.parameters, zeep_message.headers
    end
  end
end
