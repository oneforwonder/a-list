class SharesController < ApplicationController
  layout "application"
  before_filter :require_user
  
  def index
    @shares = current_user.unread_shares
  end

  def show
    @share = Share.find(params[:id])
    if @share.recipient != current_user
      redirect_to shares_path
    else
      @comment = Comment.new(:user => current_user, :link => @share.link)
    end
  end
end
