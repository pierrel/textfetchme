class HomeController < ApplicationController
  layout 'main'
  before_filter :login_required
  
  def index
  end
end
