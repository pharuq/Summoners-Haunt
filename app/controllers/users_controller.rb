class UsersController < ApplicationController
  skip_before_action :logged_in_user, only: [:new, :create]
  before_action :correct_user, only: [:edit, :edit_password, :update]
  before_action :admin_user, only: [:destroy]

  def show
    @user = User.find(params[:id])
    @diaries = @user.diaries.paginate(page: params[:page], :per_page => 5)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = "メールアドレスにアカウント有効化リンクを送信しました。メールを確認してアカウントを有効化してください。"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def edit_password
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "アカウント情報を更新しました。"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def leave
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "アカウントを削除しました。"
    redirect_to root_url
  end

  def friends
    @user  = User.find(params[:id])
    @users = @user.friends.paginate(page: params[:users], :per_page => 20)
    @pending_users = @user.passive_pending_friends.paginate(page: params[:pending_users], :per_page => 10)
    render 'user_friends'
  end

  def communities
    @user  = User.find(params[:id])
    @communities = @user.belong_communities.paginate(page: params[:page], :per_page => 20)
    render 'user_communities'
  end

  def diaries
    @user = User.find(params[:id])
    @diaries = @user.diaries.paginate(page: params[:page])
  end

  def index
    @user = current_user
    @q = User.search(search_params)
    @users = @q.result.where.not(id: @user.id).paginate(page: params[:page], :per_page => 20)
  end

  def messages
    @user = current_user
    # @messages = Message.find_by_sql(['select * FROM messages as m WHERE created_at =
    #                       (select MAX(created_at) FROM(select to_user_id as user, content, created_at
    #                         from messages where from_user_id = :user_id
		# 		                    UNION ALL select from_user_id as user, content, created_at
    #                         from messages where to_user_id = :user_id) as s
		# 		                    WHERE m.from_user_id = s.user OR m.to_user_id = s.user )
    #                         ORDER BY created_at DESC', user_id: @user])
    message_sql = ['select * FROM messages as m WHERE created_at =
                          (select MAX(created_at) FROM(select to_user_id as user, content, created_at
                            from messages where from_user_id = :user_id
  			                    UNION ALL select from_user_id as user, content, created_at
                            from messages where to_user_id = :user_id) as s
  			                    WHERE m.from_user_id = s.user OR m.to_user_id = s.user )
                            ORDER BY created_at DESC', user_id: @user]
    @messages =  Message.paginate_by_sql(message_sql, page: params[:page], per_page: 10)
  end

  def message
    @user = User.find(params[:id])
    @message = Message.new
    @messages = current_user.messages(@user).includes(:from_user).paginate(page: params[:page], :per_page => 12)
    #既読をつける
    @messages.where(["read = ? and from_user_id = ?", false, @user]).find_each do |message|
      message.update_attribute(:read, true)
    end
  end


  private

    def user_params
      params.require(:user).permit(:name, :email, :role, :profile, :password,
                                      :password_confirmation,
                                      :image_x, :image_y, :image_w, :image_h, :picture)
    end

    def search_params
      params.fetch(:q, {}).permit(:name_cont, :role_cont, :profile_cont)
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
