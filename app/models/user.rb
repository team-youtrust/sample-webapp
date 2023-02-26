# == Schema Information
#
# Table name: users
#
#  id         :bigint           unsigned, not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class User < ApplicationRecord
  validates :name, presence: true

  has_many :user_friends
  has_many :friends, through: :user_friends, source: :friend_user

  def self.lock_users(*users)
    users.map(&:id).sort.map { |user_id| lock.find(user_id) }
  end

  def friend_with?(user)
    user.id.in?(user_friends.map(&:friend_user_id))
  end

  def relationship_with(user)
    if self == user
      'me'
    elsif friend_with?(user)
      'friend'
    elsif FriendRequest.exists?(from_user: self, to_user: user)
      'sending_friend_request'
    elsif FriendRequest.exists?(from_user: user, to_user: self)
      'receiving_friend_request'
    else
      'other'
    end
  end
end
