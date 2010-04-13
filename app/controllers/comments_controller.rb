class CommentsController < ApplicationController
  layout "application"
  before_filter :require_user
  
  def create
    @comment = Comment.new(params[:comment])
    
    if @comment.save
      flash[:notice] = 'Commented added successfully.'
    else
      flash[:notice] = 'Comment could not saved. Please try again.'
    end
    
    redirect_to share_path(params[:share_id])
    # TODO: Javascript magic so we don't need to reload the page.
  end
end
