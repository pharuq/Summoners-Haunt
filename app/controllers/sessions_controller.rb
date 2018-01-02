class SessionsController < ApplicationController
  skip_before_action :logged_in_user, only: [:create]

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or root_url
      else
        message  = "アカウントが有効化されていません。 "
        message += "メールを確認してアカウントを有効化してください。"
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'メールアドレスまたはパスワードが間違っています。'
      render 'static_pages/home'
    end
  end

  def destroy
    log_out  if logged_in?
    redirect_to root_url
  end

end
