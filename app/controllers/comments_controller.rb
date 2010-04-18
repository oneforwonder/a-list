class CommentsController < ApplicationController
  layout "application"
  before_filter :require_user
  
  def create
    @share = Share.find(params[:share_id])
    if @share.recipient != current_user
      redirect_to share_path(params[:share_id]) and return
    end
      
    @comment = Comment.new(params[:comment])
    
    if @comment.save
      @share.other_shares { |s| s.update_attribute(:read, false) } # All users are notified of a new comment.
      p @share.other_shares.inspect
      flash[:notice] = 'Commented added successfully.'
    else
      flash[:notice] = 'Comment could not saved. Please try again.'
    end
    
    redirect_to share_path(params[:share_id])
    # TODO: Javascript magic so we don't need to reload the page.
  end
end
