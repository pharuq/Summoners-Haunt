module DiariesHelper

  # 日記が観覧可能かを判定する
  def shared_with?(diary)
    if diary.shared_with == SHARED_WITH_OPEN
      return true
    elsif diary.shared_with == SHARED_WITH_FRIENDS_ONLY
      diary.user.friends?(current_user)
    end
  end

end
