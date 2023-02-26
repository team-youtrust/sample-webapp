# == Schema Information
#
# Table name: user_notifications
#
#  id                :bigint           unsigned, not null, primary key
#  body              :text(65535)
#  is_read           :boolean          default(FALSE), not null
#  notification_type :integer          unsigned, not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  from_user_id      :integer          unsigned, not null
#  user_id           :integer          unsigned, not null
#
# Indexes
#
#  i1  (user_id)
#
FactoryBot.define do
  factory :user_notification do
    user { create(:user) }
    from_user { create(:user) }
    notification_type { 'notification_type_become_friend' }
    is_read { false }
    body { '{}' }
  end
end
