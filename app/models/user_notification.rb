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
require 'json'

class UserNotification < ApplicationRecord
  belongs_to :user
  belongs_to :from_user, class_name: 'User'

  enum notification_type: {
    notification_type_become_friend: 1,
  }

  def parsed_body
    JSON.parse(body)
  end
end
