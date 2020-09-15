class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  before_action :set_search
  
  def set_search
    if logged_in?
      @search_word = params[:q][:to_or_schedules_to_cont] if params[:q]
      @search = Destination.ransack(params[:q])
      @q = @search.result(distinct: true).page(params[:page])
    end
  end  
  
  private
  
  def logged_in_user
    unless logged_in?
      store_location
      redirect_to login_url
    end
  end
  
 
end
