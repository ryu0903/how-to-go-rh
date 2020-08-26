class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  
  private
  
  def logged_in_user
    unless logged_in?
      redirect_to login_url
    end
  end
  
  def correct_user
    @user = User.find(params[:id])
    if !current_user?(@user)
      redirect_to root_url
    end
  end
end
