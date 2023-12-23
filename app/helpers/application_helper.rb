module ApplicationHelper
  def bootstrap_class_for_flash(flash_type)
    case flash_type.to_sym
    when :success
      "success"
    when :error
      "danger"
    when :alert
      "warning"
    when :notice
      "info"
    else
      flash_type.to_s
    end
  end

  def user_image(user, size)
    if user.profile_image.attached?
      image_tag user.profile_image, size: size
    else
      image_tag "no_image.jpg", size: size
    end
  end

  def post_image(post, size)
    if post.post_image.attached?
      image_tag post.post_image, size: size
    else
      image_tag "no_image.jpg", size: size
    end
  end
end
