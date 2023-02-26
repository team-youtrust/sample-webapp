# == Schema Information
#
# Table name: friend_requests
#
#  id           :bigint           unsigned, not null, primary key
#  is_read      :boolean          default(FALSE), not null
#  status       :integer          unsigned, not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  from_user_id :integer          unsigned, not null
#  to_user_id   :integer          unsigned, not null
#
# Indexes
#
#  i1  (from_user_id,to_user_id) UNIQUE
#  i2  (to_user_id,from_user_id) UNIQUE
#
class FriendRequest < ApplicationRecord
  belongs_to :from_user, class_name: 'User'
  belongs_to :to_user, class_name: 'User'

  enum status: {
    status_pending: 1,
    status_accepted: 2,
  }

  def viewable_by?(user)
    user.id.in?([from_user_id, to_user_id])
  end
end
