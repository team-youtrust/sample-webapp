# == Schema Information
#
# Table name: posts
#
#  id         :bigint           unsigned, not null, primary key
#  content    :text(65535)      not null
#  created_at :datetime         not null
#  user_id    :integer          unsigned, not null
#
# Indexes
#
#  i1  (user_id)
#
class Post < ApplicationRecord
  belongs_to :user
end
