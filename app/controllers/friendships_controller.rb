class FriendshipsController < ApplicationController
  layout "application"
  before_filter :require_user

  def index
    friend_list = []
    @current_user.friends.each do |f|
      friend_list << {:name => f.name, :email => f.email}
    end

    respond_to do |format|
      format.js { render :json => {:friends => friend_list} }
    end
  end
end
