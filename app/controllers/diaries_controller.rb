class DiariesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]

  def new
    @diary = Diary.new
  end

  def create
    @diary = current_user.diaries.build(diary_params)
    if @diary.save
      flash[:success] = "Diary created!"
      redirect_to @diary
    else
      redirect_to 'static_pages/home'
    end
  end

  def show
    @diary = Diary.find(params[:id])
    @user = @diary.user
    @diary_comment = current_user.diary_comments.build
    @diary_comments = @diary.diary_comments
  end

  def edit
  end

  def update
    if @diary.update_attributes(diary_params)
      flash[:success] = "Diary Update"
      redirect_to @diary
    else
      render 'edit'
    end
  end

  def destroy
    @diary.destroy
    flash[:success] = "Diary deleted"
    redirect_to request.referrer || root_url
  end

  private

  def diary_params
    params.require(:diary).permit(:title, :content, :shared_with)
  end

  def correct_user
    @diary = current_user.diaries.find_by(id: params[:id])
    redirect_to root_url if @diary.nil?
  end

end
