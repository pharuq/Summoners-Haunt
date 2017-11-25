class CommunityCommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @community_comment = current_user.community_comments.build(community_comment_params)
    if @community_comment.save
      flash[:success] = "community_comment created!"
      redirect_to request.referrer || root_url
    end
  end

  def destroy
    @community_comment.destroy
    flash[:success] = "Diary_comment deleted"
    redirect_to request.referrer || root_url
  end

  private

  def community_comment_params
    params.require(:community_comment).permit(:community_id, :community_topic_id, :content)
  end

  def correct_user
    @community_comment = current_user.community_comments.find_by(id: params[:id])
    redirect_to root_url if @community_comment.nil?
  end

end
