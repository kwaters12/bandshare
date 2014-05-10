class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :activities
  has_many :memberships, dependent: :destroy
  has_many :bands, through: :memberships
  has_many :statuses
  has_many :user_friendships
  has_many :albums
  has_many :pictures
  has_many :instruments
  has_many :friends, through: :user_friendships,
                    # -> { where (user_friendships.map(&:state): 'accepted') }} 
                    conditions: { user_friendships: { state: 'accepted' }}

  has_many :pending_user_friendships, -> { where state: 'pending' },
                                      class_name: 'UserFriendship',
                                      foreign_key: :user_id
  has_many :pending_friends, through: :pending_user_friendships, source: :friend
  has_many :requested_user_friendships, -> { where state: 'requested' },
                                      class_name: 'UserFriendship',
                                      foreign_key: :user_id
  has_many :requested_friends, through: :pending_user_friendships, source: :friend
  has_many :blocked_user_friendships, -> { where state: 'blocked' },
                                      class_name: 'UserFriendship',
                                      foreign_key: :user_id
  has_many :blocked_friends, through: :pending_user_friendships, source: :friend

  has_attached_file :avatar, :styles => { :medium => "500x500>", :thumb => "200x200>", :large => "600x600>" }, :default_url => "missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def self.get_gravatars
    all.each do |user|
      if !user.avatar?
        user.avatar = URI.parse(user.gravatar_url)
        user.save
        print "."
      end
    end
  end

  # def friends
  #   friends = friends.where(state: 'accepted')
  # end

  def name_display
    if first_name || last_name
      "#{first_name} #{last_name}".strip
    else
      email
    end
  end

  def to_param
    profile_name
  end

  def to_s
    first_name
  end
  
  def gravatar_url
    stripped_email = email.strip
    downcased_email = stripped_email.downcase
    hash = Digest::MD5.hexdigest(downcased_email)

    "http://gravatar.com/avatar/#{hash}"
  end

  def has_blocked?(other_user)
    blocked_friends.include?(other_user)
  end

  def create_activity(item, action)
    activity = activities.new
    activity.targetable = item
    activity.action = action
    activity.save
    activity
  end

end
