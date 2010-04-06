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
    if current_user
      redirect_to shares_path
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(params[:user])
    
    if @user.save
      flash[:notice] = 'Registration successful.'
      redirect_to shares_path
    else
      flash[:error] = 'Registration failed. Please try again.'
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
      redirect_to(@user)
    else
      flash[:error] = 'Update failed. Please try again.'
      render :action => "edit"
    end
  end

  
  def destroy
    @user = User.find(params[:id])
    @user.destroy
    
    flash[:notice] = 'Account successfully deleted.'
    redirect_to root_path
  end


  def friends
    friend_list = []
    @current_user.friends.each do |f|
      friend_list << {:name => f.name, :email => f.email}
    end

    respond_to do |format|
      format.js { render :json => {:friends => friend_list} }
    end
  end
  
end
