class FavoritesController < ApplicationController
  before_action :logged_in_user
  
  def create
    @destination = Destination.find(params[:destination_id])
    current_user.favorite(@destination)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end
  
  def destroy
    @destination = Destination.find(params[:destination_id])
    current_user.unfavorite(@destination)
    respond_to do |format|
      format.html { redirect_to request.referrer || root_url }
      format.js
    end
  end
  
end
