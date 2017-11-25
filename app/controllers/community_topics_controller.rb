class CommunityTopicsController < ApplicationController
  before_action :belong_communities_user, only: [:new, :create, :edit, :update]

  def new
    @community = Community.find(params[:community_id])
    @community_topic = CommunityTopic.new
  end

  def create
    @community = Community.find(params[:community_id])
    @community_topic = CommunityTopic.new(community_topic_params)
    if @community_topic.save
      flash[:success] = "Community_topic created!"
      redirect_to community_community_topic_path(@community, @community_topic)
    else
      render 'static_pages/home'
    end
  end

  def edit
  end

  def update
  end

  def show
    @community = Community.find(params[:community_id])
    @community_topic = CommunityTopic.find(params[:id])
    @community_comment = current_user.community_comments.build
    @community_comments = @community_topic.community_comments
  end

  def destroy
    @community = Community.find(params[:community_id])
    CommunityTopic.find(params[:id]).destroy
    flash[:success] = "CommunityTopic deleted"
    redirect_to @community
  end

  def index
  end

  private

  def community_topic_params
    params.require(:community_topic).permit(:title, :content, :community_id, :user_id)
  end

    # beforeアクション

    # コミュニティに属しているかどうか確認
    def belong_communities_user
      @community = Community.find(params[:community_id])
      redirect_to root_url unless current_user.belong_communities?(@community)
    end
end
