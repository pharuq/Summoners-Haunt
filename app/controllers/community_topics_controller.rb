class CommunityTopicsController < ApplicationController
  before_action :belong_communities_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    @community = Community.find(params[:community_id])
    @community_topic = CommunityTopic.new
  end

  def create
    @community = Community.find(params[:community_id])
    @community_topic = CommunityTopic.new(community_topic_params)
    if @community_topic.save
      flash[:success] = "トピックを作成しました。"
      redirect_to community_community_topic_path(@community, @community_topic)
    else
      render 'new'
    end
  end

  def edit
    @community = Community.find(params[:community_id])
    @community_topic = CommunityTopic.find(params[:id])
  end

  def update
    @community = Community.find(params[:community_id])
    @community_topic = CommunityTopic.find(params[:id])
    if @community_topic.update_attributes(community_topic_params)
      flash[:success] = "トピックを更新しました。"
      redirect_to community_community_topic_path(@community, @community_topic)
    else
      render 'edit'
    end
  end

  def show
    @community = Community.find(params[:community_id])
    @user = @community.user
    @community_topic = CommunityTopic.find(params[:id])
    @community_comment = current_user.community_comments.build
    @community_comments = @community_topic.community_comments.includes(:user).paginate(page: params[:page], :per_page => 7)
  end

  def destroy
    @community = Community.find(params[:community_id])
    CommunityTopic.find(params[:id]).destroy
    flash[:success] = "トピックを削除しました。"
    redirect_to @community
  end

  private

  def community_topic_params
    params.require(:community_topic).permit(:title, :content, :community_id, :user_id)
  end

    # beforeアクション

  # コミュニティに属しているかどうか確認
  def belong_communities_user
    @community = Community.find(params[:community_id])
    unless current_user.belong_communities?(@community)
      flash[:danger] = "コミュニティに参加していないと操作できません。"
      redirect_to request.referrer || root_url
    end
  end
end
