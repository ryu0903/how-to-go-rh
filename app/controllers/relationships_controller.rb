class RelationshipsController < ApplicationController
  before_action :logged_in_user
  
  def create
    @user = User.find(params[:follow_id])
    current_user.follow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js 
    end
    
    if @user != current_user
      @user.notifications.create(follow_id: @user.id, 
                                 variety: 3,
                                 from_user_id: current_user.id)
      @user.update_attribute(:notification, true)
    end
  end
  
  def destroy
    @user = Relationship.find(params[:id]).follow
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
end
