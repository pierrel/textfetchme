class AccountsController < ApplicationController
  layout 'main'
  

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
  end

  def login
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/triggers')
    else
      flash[:error] = "Incorrect username or password"      
    end
  end

  def signup
    if request.post?
      @user = User.new(params[:user])
      @user.plan = Plan.find(:first, :conditions => 'price = 0') # TODO: change to some default method in Plan
      @user.save!
      self.current_user = @user
      redirect_to :action => 'phone_confirmation'
    end
        
  rescue ActiveRecord::RecordInvalid
    flash[:error] = "Could not sign you up, please try again"
    render :action => 'signup'
  end
  
  def phone_confirmation
    @user = current_user
    
    unless logged_in? || User.count > 0
      redirect_to(:action => 'signup')
    end
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/accounts', :action => 'login')
  end
  
  def preferences
    @user = current_user
  end
  
  def update_user_prefs
    @user = current_user
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = "Preferences saved!"
        format.html {redirect_to :controller => 'triggers', :action => 'index'}
        format.xml { head :ok }
      else
        flash[:error] = "Preferences could not be saved"
        format.html { render :action => 'preferences' }
        format.xml { render :xml => @user.errors, :status => :unprocessable_entity}
      end
    end
  end
  
  # TODO: write change_password
  def change_password
    if request.post?
    end
  end
  
end
