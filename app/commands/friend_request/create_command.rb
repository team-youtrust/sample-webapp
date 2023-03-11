class FriendRequest::CreateCommand
  include Command

  attr_reader :from_user, :to_user, :friend_request

  validate :validate_to_user

  def run
    @friend_request = FriendRequest.create!(
      from_user: from_user,
      to_user: to_user,
      status: :status_pending,
      is_read: false,
    )
  end

  def initialize(from_user:, to_user:)
    @from_user = from_user
    @to_user = to_user
  end

  private

  def validate_to_user
    errors.add(:to_user, :invalid) if FriendRequest.where(from_user: from_user, to_user: to_user).exists?
    errors.add(:to_user, :invalid) if FriendRequest.where(from_user: to_user, to_user: from_user).exists?
    errors.add(:to_user, :invalid) if from_user == to_user
    errors.add(:to_user, :invalid) if from_user.friend_with?(to_user)
  end
end
