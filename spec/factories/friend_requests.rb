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
FactoryBot.define do
  factory :friend_request do
    from_user { create(:user) }
    to_user { create(:user) }
    status { 'status_pending' }
  end
end
