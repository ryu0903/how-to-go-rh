class DestinationsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user, only: [:edit, :update, :destroy]
  
  def new
    @destination = Destination.new
  end
  
  def show
    @destination = Destination.find(params[:id])
    @comment = Comment.new
    @comments = @destination.comments
  end
  
  def create
    @destination = current_user.destinations.build(destination_params)
    
    if @destination.save
      flash[:success] = "投稿しました！"
      redirect_to destination_path(@destination)
    else
      flash.now[:danger] = "投稿に失敗しました。"
      render 'destinations/new'
    end
  end
  
  def edit
    @destination = Destination.find(params[:id])
  end
  
  def update
    @destination = Destination.find(params[:id])
    if @destination.update_attributes(destination_params)
      flash[:success] = "投稿を更新しました！"
      redirect_to @destination
    else
      flash.now[:danger] = "更新に失敗しました。"
      render 'edit'
    end
  end
  
  def destroy
    
    if current_user.admin? || current_user?(@destination.user)
      @destination.destroy
      flash[:success] = "投稿を削除しました。"
      redirect_to request.referrer == user_url(@destination.user) ? user_url(@destination.user) : root_url
    else
      flash[:danger] = "他のユーザーの投稿は削除できません。"
      redirect_to root_url
    end
  end
  
  private
  
    def destination_params
      params.require(:destination).permit(:to, :from, :time, :date, :outline, :detail, :notice, :reference, :picture)
    end
    
    def correct_user
      @destination = current_user.destinations.find_by(id: params[:id])
      unless @destination
        redirect_to root_url
      end
    end
end
