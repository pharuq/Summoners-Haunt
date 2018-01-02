class DiariesController < ApplicationController
  before_action :correct_user,   only: [:edit, :update, :destroy]

  def new
    @user = current_user
    @diary = Diary.new
  end

  def create
    @user = current_user
    @diary = @user.diaries.build(diary_params)
    if @diary.save
      flash[:success] = "日記を作成しました。"
      redirect_to @diary
    else
      render 'new'
    end
  end

  def show
    @diary = Diary.find(params[:id])
    @user = @diary.user
    @diary_comment = current_user.diary_comments.build
    @diary_comments = @diary.diary_comments.includes(:user).paginate(page: params[:page], :per_page => 7)
  end

  def edit
    @user = current_user
  end

  def update
    if @diary.update_attributes(diary_params)
      flash[:success] = "日記を更新しました。"
      redirect_to @diary
    else
      render 'edit'
    end
  end

  def destroy
    @diary.destroy
    flash[:success] = "日記を削除しました。"
    redirect_to root_url
  end

  private

  def diary_params
    params.require(:diary).permit(:title, :content, :shared_with, {pictures: []})
  end

  def correct_user
    @diary = current_user.diaries.find_by(id: params[:id])
    redirect_to root_url if @diary.nil?
  end

end
