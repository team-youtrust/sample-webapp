# == Schema Information
#
# Table name: user_friends
#
#  id             :bigint           unsigned, not null, primary key
#  created_at     :datetime         not null
#  friend_user_id :integer          unsigned, not null
#  user_id        :integer          unsigned, not null
#
# Indexes
#
#  i1  (user_id,friend_user_id) UNIQUE
#
class UserFriend < ApplicationRecord
  belongs_to :user
  belongs_to :friend_user, class_name: 'User'
end
