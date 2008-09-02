class IncomingController < ApplicationController
  skip_before_filter :verify_authenticity_token
  
  def index
    if request.post?
      add_command = /add ([\w\d]+) ([\d\w ]+)/ # TODO: implement add command
      add_to_command = /addto ([\w\d]+) ([\d\w ]+)/ # TODO: implement addto command
      remove_command = /remove ([\w\d]+)/ # TODO: implement remove command
      body= params[:body].downcase
      user = User.find(params[:uid])
      if not user.nil?
        matching_triggers = user.triggers.select { |trigger| trigger.key.downcase == body }
        if matching_triggers.size != 1
          # if body.match(add_command)
          #   if user.more_triggers?
          #     data = body.match(add_command)
          #     new_trigger = Trigger.new(:key => data[1], :value => data[2])
          #     user.triggers << new_trigger
          #     text = "New trigger '#{data[1]}' added."
          #   else
          #     text = "You have too many triggers to add another."
          #   end
          # elsif body.match(remove_command)
          #   data = body.match(remove_command)
          #   matching_triggers = user.triggers.select { |trigger| trigger.key == data[1] }
          #   if matching_triggers.size == 1
          #     user.triggers.delete(matching_triggers[0])
          #     user.save!
          #     text = "Trigger '#{data[1]}' removed."
          #   else
          #     text = "No trigger matched '#{data[1]}'"
          text = "'#{params[:body]}' not found. These are your triggers: #{user.triggers.collect {|trigger| trigger.key }.join(", ")}."
        else
          text = matching_triggers[0].value
        end
      else
        render :text => "error, no user", :status => 400
      end
      render :text => text, :status => 200, :content_type => 'text/plain'
    end
  end
end
