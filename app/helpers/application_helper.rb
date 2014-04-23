module ApplicationHelper

  def avatar_profile_link(user, image_options={}, html_options={})
    avatar_url = user.avatar? ? user.avatar.url : nil
    link_to(image_tag(avatar_url, image_options), profile_path(user.profile_name), html_options)
  end

  def band_logo_display(band)
    if band.document && band.document.attachment?
      content_tag(:span, "Logo", class: "label label-info") +
      image_tag(band.document.attachment.url(:large))
    end
  end

  def can_display_band(band)
    signed_in? && !current_user.has_blocked?(band.user) || !signed_in?
  end

  def page_header(&block)
    content_tag(:div, capture(&block), class: 'page-header')
  end
  
end
