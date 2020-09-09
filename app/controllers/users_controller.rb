class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :followings, :followers, :favorites]
  before_action :correct_user, only: [:edit, :update]
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @destinations = @user.destinations.page(params[:page]).per(5)
  end

  def index
    @users = User.all.page(params[:page])
  end
  
  def create
    @user = User.new(user_params)
      if @user.save
        log_in(@user)
        flash[:success] = 'How to Goへようこそ！!'
        redirect_to @user
      else 
        render 'new'
      end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    
    if @user.update(user_params_for_update)
      flash[:success] = "プロフィールが更新されました！"
      redirect_to @user
    else
      flash.now[:danger] = "プロフィールの更新に失敗しました。"
      render 'edit'
    end
  end
  
  def destroy
    @user = User.find(params[:id])
    
    if current_user.admin?
      @user.destroy
      flash[:success] = "アカウントを削除しました。"
      redirect_to users_url
    elsif current_user?(@user)
      @user.destroy
      flash[:success] = "アカウントを削除しました。"
      redirect_to root_url
    else
      flash[:danger] = "他のユーザーを削除することはできません。"
      redirect_to root_url
    end
    
  end  
  
  def followings
    @user = User.find(params[:id])
    @title = 'Follow'
    @followings = @user.followings.page(params[:page]).per(10)
  end
  
  def followers
    @user = User.find(params[:id])
    @title = 'Follower'
    @followers = @user.followers.page(params[:page]).per(10)
  end
  
  def favorites
    @user = User.find(params[:id])
    @favorites = @user.favorites.page(params[:page]).per(5)
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def user_params_for_update
      params.require(:user).permit(:name, :email, :introduce)
    end
    
     def correct_user
      @user = User.find(params[:id])
      if !current_user?(@user)
       redirect_to root_url
      end
     end
    
end
