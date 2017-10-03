class MessagesController < ApplicationController


  def new
    @user = User.find(params[:user_id])
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    if @message.save
      flash[:success] = "Message created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def index
    @messages = current_user.messages(params[:user_id])
  end

  private

  def message_params
    params.require(:message).permit(:from_user_id, :to_user_id, :content)
  end

end
