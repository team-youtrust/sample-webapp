# == Schema Information
#
# Table name: users
#
#  id         :bigint           unsigned, not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "user#{n}" }
  end
end
