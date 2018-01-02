module ApplicationHelper
    # ページごとの完全なタイトルを返します。
    def full_title(page_title = '')
        base_title = "Summoner's Haunt"
        if page_title.empty?
          base_title
        else
          page_title + " | " + base_title
        end
    end

    # HTMLで書けない文字の実体参照と改行コードのHTMLへの置換を行う
    def hbr(target)
      target = html_escape(target)
      target.gsub(/\r\n|\r|\n/, "<br />")
    end

    def show_big_thumb(user)
      if user.picture.present?
        image_tag(user.picture.url(:big_thumb), alt: user.name, class: "img-thumbnail center-block")
      else
        image_tag('/m_e_others_480_240x240.jpg', alt: user.name, class: "img-thumbnail center-block")
      end
    end

    def show_middle_thumb(user)
      if user.picture.present?
        link_to image_tag(user.picture.url(:thumb), alt: user.name, class: "center-block"), user
      else
        link_to image_tag('/m_e_others_480_80x80.jpg', alt: user.name, class: "center-block"), user
      end
    end

    def show_mini_thumb(user)
      if user.picture.present?
        link_to image_tag(user.picture.url(:mini_thumb), alt: user.name, class: "img-circle"), user
      else
        link_to image_tag('/m_e_others_480_24x24.jpg', alt: user.name, class: "img-circle"), user
      end
    end

    def show_message_thumb(user)
      if user.picture.present?
        link_to image_tag(user.picture.url(:thumb), alt: user.name, class: "center-block"), message_user_path(user)
      else
        link_to image_tag('/m_e_others_480_80x80.jpg', alt: user.name, class: "center-block"), message_user_path(user)
      end
    end

    def show_no_link_thumb(user)
      if user.picture.present?
        image_tag(user.picture.url(:thumb), alt: user.name, class: "center-block")
      else
        image_tag('/m_e_others_480_80x80.jpg', alt: user.name, class: "center-block")
      end
    end

end
