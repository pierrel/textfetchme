class SignupController < ApplicationController
  def index
    redirect_to :controller => '/accounts', :action => 'signup'
  end
end
