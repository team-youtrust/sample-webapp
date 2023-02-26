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
FactoryBot.define do
  factory :post do
    user { create(:user) }
    sequence(:content) { |n| "content#{n}" }
  end
end
