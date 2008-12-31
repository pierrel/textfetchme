class ProspectiveUsersController < ApplicationController

  before_filter :login_required

  # GET /prospective_users
  # GET /prospective_users.xml
  def index
    @prospective_users = ProspectiveUser.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @prospective_users }
    end
  end

  # GET /prospective_users/1
  # GET /prospective_users/1.xml
  def show
    @prospective_user = ProspectiveUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @prospective_user }
    end
  end

  # GET /prospective_users/new
  # GET /prospective_users/new.xml
  def new
    @prospective_user = ProspectiveUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @prospective_user }
    end
  end

  # GET /prospective_users/1/edit
  def edit
    @prospective_user = ProspectiveUser.find(params[:id])
  end

  # POST /prospective_users
  # POST /prospective_users.xml
  def create
    @prospective_user = ProspectiveUser.new(params[:prospective_user])

    respond_to do |format|
      if @prospective_user.save
        flash[:notice] = 'ProspectiveUser was successfully created.'
        format.html { redirect_to(@prospective_user) }
        format.xml  { render :xml => @prospective_user, :status => :created, :location => @prospective_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @prospective_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /prospective_users/1
  # PUT /prospective_users/1.xml
  def update
    @prospective_user = ProspectiveUser.find(params[:id])

    respond_to do |format|
      if @prospective_user.update_attributes(params[:prospective_user])
        flash[:notice] = 'ProspectiveUser was successfully updated.'
        format.html { redirect_to(@prospective_user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @prospective_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /prospective_users/1
  # DELETE /prospective_users/1.xml
  def destroy
    @prospective_user = ProspectiveUser.find(params[:id])
    @prospective_user.destroy

    respond_to do |format|
      format.html { redirect_to(prospective_users_url) }
      format.xml  { head :ok }
    end
  end
end
