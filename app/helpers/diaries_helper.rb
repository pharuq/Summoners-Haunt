module DiariesHelper

  # 日記が観覧可能かを判定する
  def shared_with?(diary)
    if diary.shared_with == SHARED_WITH_OPEN
      return true
    elsif diary.shared_with == SHARED_WITH_FRIENDS_ONLY
      user = current_user
      if diary.user == user
        return true
      else
        diary.user.friends?(user)
      end
    end
  end

end
