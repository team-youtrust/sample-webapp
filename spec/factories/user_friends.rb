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
FactoryBot.define do
  factory :user_friend do
    user { create(:user) }
    friend_user { create(:user) }
  end
end
