module TriggersHelper
  def add_triggers_button(user)
    if user.more_triggers?
      link_to_remote("Add another trigger (#{user.triggers_left} left)", :update => 'trigger_list', :url => {:action => 'new_trigger_for_user'})
    else
      "You have no triggers left, " + link_to("upgrade", {:controller => 'accounts', :action => 'preferences'}) + " for more"
    end
  end
  
  def default_trigger_key
    "Trigger"
  end
  
  def default_trigger_value
    "Information"
  end
end
