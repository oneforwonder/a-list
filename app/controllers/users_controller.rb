class UsersController < ApplicationController
  layout "application"
  before_filter :authenticate_user, :except => [:new, :create, :activate]
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])

    if @user == current_user
      # For now, whenever a user goes to their own user page,
      # they will be sent to edit action where they can edit
      # their preferences.
      # If we add profiles, then we might show the user their profile
      # here and provide a link to edit their profile or preferences.      
      redirect_to edit_user_path(current_user)

    elsif !current_user.friends.include?(@user)
      # Prevent users from seeing the full name and email address
      # of users they are not friends with.
      redirect_to root_url
      flash[:error] = 'You may only view the profile of users you are friends with.'
    end
    
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
    
    # Saving without session maintenance to skip
    # auto-login which can't happen here because
    # the User has not yet been activated
    if @user.save_without_session_maintenance
      @user.deliver_activation_instructions
      flash[:notice] = 'Registration successful. Please check your email to activate your account.'
      redirect_to shares_path
    else
      flash[:error] = 'Registration failed. Please try again.'
      redirect_to root_path
    end
  end
  
  
  def activate
    @user = User.find_using_perishable_token(params[:token], 0) # Token does not expire.
    if !@user
      redirect_to root_url
    else
      if !@user.active?
        @user.activated = true
        @user.save
        UserSession.create(@user) # Log the user in.
        flash[:notice] = 'Account activated successfully.'
      end
      
      redirect_to shares_path
    end
  end
  
  def edit
    @user = current_user
  end
  
  def update
    @user = current_user
    
    if @user.update_attributes(params[:user])
      flash[:notice] = 'Settings updated successfully.'
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
