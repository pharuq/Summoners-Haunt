class MessagesController < ApplicationController

  def create
    @message = Message.new(message_params)
    if @message.save
      # flash[:success] = "Message created!"
      # @user = User.find(params[:to_user_id])
      redirect_to request.referrer || root_url
    else
      flash[:danger] =  "メッセージに失敗しました。"
      redirect_to  request.referrer || root_url
    end
  end

  private

  def message_params
    params.require(:message).permit(:from_user_id, :to_user_id, :content)
  end

end
