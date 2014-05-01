module ApplicationHelper

  def bootstrap_paperclip_picture(form, paperclip_object)
    if form.object.send("#{paperclip_object}?")
      content_tag(:div, class: "control-group") do
        content_tag(:label, "Current #{paperclip_object.to_s.titleize}", class: 'control-label') +
        content_tag(:div, class: "controls") do
          image_tag form.object.send(paperclip_object).send(:url, :medium)
        end
      end
    end
  end

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
