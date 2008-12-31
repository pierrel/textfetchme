class BetaCodesController < ApplicationController

  before_filter :login_required, :admin_required

  # GET /beta_codes
  # GET /beta_codes.xml
  def index
    @beta_codes = BetaCode.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @beta_codes }
    end
  end

  # GET /beta_codes/1
  # GET /beta_codes/1.xml
  def show
    @beta_code = BetaCode.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @beta_code }
    end
  end

  # GET /beta_codes/new
  # GET /beta_codes/new.xml
  def new
    @beta_code = BetaCode.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @beta_code }
    end
  end

  # GET /beta_codes/1/edit
  def edit
    @beta_code = BetaCode.find(params[:id])
  end

  # POST /beta_codes
  # POST /beta_codes.xml
  def create
    @beta_code = BetaCode.new(params[:beta_code])

    respond_to do |format|
      if @beta_code.save
        flash[:notice] = 'BetaCode was successfully created.'
        format.html { redirect_to(@beta_code) }
        format.xml  { render :xml => @beta_code, :status => :created, :location => @beta_code }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @beta_code.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /beta_codes/1
  # PUT /beta_codes/1.xml
  def update
    @beta_code = BetaCode.find(params[:id])

    respond_to do |format|
      if @beta_code.update_attributes(params[:beta_code])
        flash[:notice] = 'BetaCode was successfully updated.'
        format.html { redirect_to(@beta_code) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @beta_code.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /beta_codes/1
  # DELETE /beta_codes/1.xml
  def destroy
    @beta_code = BetaCode.find(params[:id])
    @beta_code.destroy

    respond_to do |format|
      format.html { redirect_to(beta_codes_url) }
      format.xml  { head :ok }
    end
  end
end
