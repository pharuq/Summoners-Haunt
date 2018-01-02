class CommunitiesController < ApplicationController
  def new
    @community = Community.new
  end

  def create
    @user = current_user
    @community = @user.communities.build(community_params)
    if @community.save
      @community.invite(@user)
      flash[:success] = "コミュニティを作成しました！"
      redirect_to @community
    else
      render 'new'
    end
  end

  def show
    @community = Community.find(params[:id])
    @community_topics = @community.community_topics.includes(:user).paginate(page: params[:page], :per_page => 7)
  end

  def edit
    @community = Community.find(params[:id])
  end

  def update
    @community = Community.find(params[:id])
    if @community.update_attributes(community_update_params)
      flash[:success] = "コミュニティ情報を更新しました。"
      redirect_to @community
    else
      render 'edit'
    end
  end

  def destroy
    Community.find(params[:id]).destroy
    flash[:success] = "コミュニティを削除しました。"
    redirect_to communities_url
  end

  def index
    @q = Community.search(search_params)
    @communities = @q.result
  end

  def members
    @community  = Community.find(params[:id])
    @users = @community.community_members.paginate(page: params[:page], :per_page => 20)
  end

  private

    def community_params
      params.require(:community).permit(:name, :content,
                                      :image_x, :image_y, :image_w, :image_h, :picture)
    end

    def community_update_params
      if params[:authority_transfer]
        params.require(:community).permit(:name, :content, :user_id,
                                      :image_x, :image_y, :image_w, :image_h, :picture)
      else
        params.require(:community).permit(:name, :content,
                                      :image_x, :image_y, :image_w, :image_h, :picture)
      end
    end

    def search_params
      params.fetch(:q, {}).permit(:name_cont, :content_cont)
    end

    # beforeアクション

    def correct_user
      # @user = User.find(params[:id])
      # redirect_to root_url unless current_user?(@user)
    end

end
