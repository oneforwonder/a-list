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
      redirect_to shares_path
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
    
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Profile successfully updated.'
      format.html { redirect_to(@user) }
    else
      flash[:notice] = 'Update failed. Please try again.'
      render :action => "edit"
    end
  end

  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    flash[:notice] = 'Account successfully deleted.'
    redirect_to root_path
  end
end
