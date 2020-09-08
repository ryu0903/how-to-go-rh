class CommentsController < ApplicationController
  before_action :logged_in_user
  
  def create
    @destination = Destination.find(params[:destination_id])
    @comment = @destination.comments.build(comment_params)
    @comment.user_id = current_user.id
    @user = @comment.destination.user
    if @comment.save
      respond_to do |format|
        format.html  { redirect_to @destination }
        format.js 
      end
      
      if @user != current_user
        @user.notifications.create(destination_id: @destination.id, variety: 2,
                                   from_user_id: current_user.id,
                                   content: @comment.content)
        @user.update_attribute(:notification, true)
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @destination = @comment.destination
    if current_user.id == @comment.user.id 
      @comment.destroy
      respond_to do |format|
        format.html  { redirect_to @destination }
        format.js 
      end
    else
      redirect_to 'destinations/show'
    end
  end
  
  private
    def comment_params
      params.require(:comment).permit(:content, :item_id, :user_id)
    end
    
end
