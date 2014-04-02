class UserFriendshipDecorator < Draper::Decorator
  decorate :user_friendship

  delegate_all
  # delegate :user, to: :user_friendship
  # delegate :friend, to: :user_friendship

  def friendship_state
    model.state.titleize
  end

  def sub_message
    case model.state
    when 'pending'
      "Do you really want to be friends with #{model.friend.name_display}?"
    when 'accepted'
      "You are now friends with #{model.friend.name_display}"
    end
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

end
