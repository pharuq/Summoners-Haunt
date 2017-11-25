class CommunitiesController < ApplicationController
  def new
    @community = Community.new
  end

  def create
    @user = current_user
    @community = @user.communities.build(community_params)
    if @community.save
      @community.invite(@user)
      flash[:success] = "Community created!"
      redirect_to @community
    else
      render 'new'
    end
  end

  def show
    @user = current_user
    @community = Community.find(params[:id])
    @community_topics = @community.community_topics.paginate(page: params[:page], :per_page => 7)
  end

  def edit
    @user = current_user
    @community = Community.find(params[:id])
  end

  def update
    @community = Community.find(params[:id])
    if @community.update_attributes(community_update_params)
      flash[:success] = "Community Update"
      redirect_to @community
    else
      render 'edit'
    end
  end

  def destroy
    Community.find(params[:id]).destroy
    flash[:success] = "Community deleted"
    redirect_to communities_url
  end

  def index
    @q = Community.search(search_params)
    @communities = @q.result
  end

  def members
    @community  = Community.find(params[:id])
    @user = current_user
    @users = @community.community_members.paginate(page: params[:page], :per_page => 20)
    render 'show_members'
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
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end

end
