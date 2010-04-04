class UsersController < ApplicationController
  layout "application"
  
  before_filter :authenticate_user, :except => [:new, :create]
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    
    if @user.save
      flash[:notice] = 'Registration successful.'
      redirect_to(@user)
    else
      flash[:notice] = 'Registration failed. Please try again.'
      redirect_to root_path
    end
  end

  def edit
    @user = current_user
  end
  
  def update
    @user = current_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    flash[:notice] = 'Account successfully deleted.'
    redirect_to root_path
  end
end
