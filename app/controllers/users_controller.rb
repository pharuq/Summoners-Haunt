class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:edit, :update, :destroy,
                                        :friends, :feed, :search]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @diaries = @user.diaries
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile Update"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def friends
    @user  = User.find(params[:id])
    @users = @user.friends.paginate(page: params[:page])
    render 'show_friends'
  end

  def feed
    if logged_in?
      @user = current_user
      @diaries = current_user.feed.paginate(page: params[:page])
    end
  end

  def diaries
    @user = User.find(params[:id])
    @diaries = @user.diaries.paginate(page: params[:page])
  end

  def index
    @user = current_user
    @users = User.search(params[:search])
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :role, :profile, :password, :password_confirmation, :picture)
    end

    # beforeアクション

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end

    # 管理者かどうか確認
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end