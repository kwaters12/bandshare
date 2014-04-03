module ApplicationHelper
  def can_display_band(band)
    signed_in? && !current_user.has_blocked?(band.owner) || !signed_in?
  end
end
