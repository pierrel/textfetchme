class TriggersController < ApplicationController
  layout 'main'
  
  before_filter :login_required
  in_place_edit_for :trigger, :key
  in_place_edit_for :trigger, :value
  
  # GET /triggers
  # GET /triggers.xml
  def index
    @triggers = current_user.triggers
    @user = current_user

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @triggers }
    end
  end
  
  def new_trigger_for_user
    @user = User.find(params[:id])
    if @user.more_triggers?
      @trigger = Trigger.new(:key => 'Trigger', :value => 'Information')    
      @user.add_trigger(@trigger)
      @triggers = @user.triggers
      render :partial => 'trigger_list'
    else
      flash[:error] = "Trigger could not be added to your account, please check that you have enough space" # TODO: fix ugly wording
      redirect_to :action => 'preferences'
    end
  end
  
  # GET /triggers/new
  # GET /triggers/new.xml
  def new
    @trigger = Trigger.new

    respond_to do |format|
      format.html { render :partial => 'trigger_list' }
      format.xml  { render :xml => @trigger }
    end
  end

  # GET /triggers/1/edit
  def edit
    @trigger = Trigger.find(params[:id])
  end

  # POST /triggers
  # POST /triggers.xml
  def create
    params[:trigger][:user_id] = current_user.id # setup the user_id to point to the current user
    @trigger = Trigger.new(params[:trigger])

    respond_to do |format|
      if @trigger.save
        flash[:notice] = 'Trigger was successfully created.'
        format.html { redirect_to :action => 'index' }
        format.xml  { render :xml => @trigger, :status => :created, :location => @trigger }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @trigger.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /triggers/1
  # PUT /triggers/1.xml
  def update
    @trigger = Trigger.find(params[:id])

    respond_to do |format|
      if @trigger.update_attributes(params[:trigger])
        flash[:notice] = 'Trigger was successfully updated.'
        format.html { redirect_to(@trigger) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @trigger.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /triggers/1
  # DELETE /triggers/1.xml
  def destroy
    @trigger = Trigger.find(params[:id])
    @trigger.destroy

    respond_to do |format|
      format.html { redirect_to(triggers_url) }
      format.xml  { head :ok }
    end
  end
end