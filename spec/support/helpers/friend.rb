module Helpers
  module Friend
    def make_friends(user1, user2)
      create(:user_friend, user: user1, friend_user: user2)
      create(:user_friend, user: user2, friend_user: user1)
    end
  end
end
