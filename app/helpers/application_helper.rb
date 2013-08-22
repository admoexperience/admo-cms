module ApplicationHelper

  def content_thumbnail(content)
    return if content
    if content.is_image
      image_tag(content.thumb_url)
    else
      link_to(image_tag('video-icon.png'),content.value.url)
    end
  end
end
