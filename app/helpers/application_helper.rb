module ApplicationHelper

  def band_logo_display(band)
    if band.document && band.document.attachment?
      content_tag(:span, "Logo", class: "label label-info") +
      image_tag(band.document.attachment.url(:medium))
    end
  end

  def can_display_band(band)
    signed_in? && !current_user.has_blocked?(band.user) || !signed_in?
  end
end
