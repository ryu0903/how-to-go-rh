class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def index
  end
  
  def create
    @user = User.new(user_params)
      if @user.save
        log_in(@user)
        flash[:success] = 'Welcome to How to Go!'
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
      flash[:success] = "Profile Updated"
      redirect_to @user
    else
      flash.now[:danger] = "Profile update failed"
      render 'edit'
    end
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    def user_params_for_update
      params.require(:user).permit(:name, :email, :introduce)
    end
    
end
