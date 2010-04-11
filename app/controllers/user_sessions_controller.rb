class UserSessionsController < ApplicationController
  layout "application"
  before_filter :authenticate_user, :only => [:destroy]
  
  def new
    @user_session = UserSession.new
  end
  
  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = 'Successfully logged in.'
      redirect_to_destination_or_default shares_path
    else
      render :action => 'new'
    end
  end
  
  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    
    flash[:notice] = 'Successfully logged out.'
    redirect_to root_url
  end
end