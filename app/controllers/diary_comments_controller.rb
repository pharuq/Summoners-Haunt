class DiaryCommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy

  def create
    @diary_comment = current_user.diary_comments.build(diary_comment_params)
    if @diary_comment.save
      flash[:success] = "コメントしました。"
      redirect_to request.referrer || root_url
    else
      flash[:danger] =  "コメントに失敗しました。"
      redirect_to  request.referrer || root_url
    end
  end

  def destroy
    @diary_comment.destroy
    flash[:success] = "コメントを削除しました。"
    redirect_to request.referrer || root_url
  end

  private

  def diary_comment_params
    params.require(:diary_comment).permit(:diary_id, :content)
  end

  def correct_user
    @diary_comment = current_user.diary_comments.find_by(id: params[:id])
    redirect_to root_url if @diary_comment.nil?
  end

end
