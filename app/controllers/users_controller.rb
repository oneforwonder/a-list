class UsersController < ApplicationController
  layout "application"
  before_filter :authenticate_user, :except => [:new, :create, :activate, :finish_registration]
  
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

  # This method can be called in one of three cases:
  #   1.The user is not in the system and attempts to sign-up
  #   2.The user is in the system (because someone has shared a link with them)
  #     but they are still trying to sign-up through the homepage
  #   3.The user is in the system (because someone has shared a link with them)
  #     and they are signing up through the email they recieved 
  #     (via the finish_registration action which calls this one)
  def create
    @user = User.find_by_email_and_activated(params[:user][:email], false) # We can only register a user that hasn't been activated yet.
    
    if @user
      # Cases 2 and 3.
      params[:user].delete(:email) # They can't arbitrarily change their email address.
      @user = User.update_attributes(params[:user])
    else
      # Case 1.
      @user = User.new(params[:user])
    end
    
    # This is true when a user finishes their registration from a link in their email (Case 3),
    # which means we don't need to send an activation link.
    if params[:token] && User.find_using_perishable_token(params[:token], 0) == @user
      activate
    else
      # Cases 1 and 2. 
      # Saving without session maintenance to skip
      # auto-login which can't happen here because
      # the user has not yet been activated
      if @user.save_without_session_maintenance
        @user.deliver_activation_instructions
        flash[:notice] = 'Registration successful. Please check your email to activate your account.'
        redirect_to shares_path
      else
        flash[:error] = 'Registration failed. Please try again.'
        redirect_to root_path
      end
    end
  end
  
  
  def activate
    @user = User.find_using_perishable_token(params[:token], 0) # Token does not expire.
    if !@user
      redirect_to root_url
    else
      if !@user.active?
        @user.activated = true
        @user.reset_perishable_token!
        @user.save
        UserSession.create(@user) # Log the user in.
        flash[:notice] = 'Account activated successfully.'
      end
      
      redirect_to shares_path
    end
  end
  
  def finish_registration
    @user = User.find_using_perishable_token(params[:token], 0) # Token does not expire.
    if !@user
      redirect_to root_url and return
    end
    
    @names = User.shares.collect { |s| s.link.submitter.name }.uniq.to_sentence
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
