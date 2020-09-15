class ToppagesController < ApplicationController
  def home
    if logged_in?
      @destinations = current_user.feed_destination.order(id: :desc).page(params[:page]).per(5)
      @title = "Everyone's Posts"
    else
      @title = "What's How to Go?"
    end
  end
end
