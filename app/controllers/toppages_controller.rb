class ToppagesController < ApplicationController
  def home
    if logged_in?
      @feed_destination_items = current_user.destination_feed.order(id: :desc).page(params[:page]).per(5)
    end
  end
end
