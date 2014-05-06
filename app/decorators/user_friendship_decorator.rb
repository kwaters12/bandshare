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

  def update_action_verbiage
    case model.state
    when 'pending'
      'Delete'
    when 'requested'
      'Accept'
    when 'accepted'
      'Update'
    when 'blocked'
      'Unblock'
    end
  end


end
