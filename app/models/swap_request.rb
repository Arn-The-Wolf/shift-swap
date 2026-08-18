class SwapRequest < ApplicationRecord
  STATUSES = %w[pending approved denied].freeze

  belongs_to :requesting_user, class_name: "User"
  belongs_to :target_user, class_name: "User"
  belongs_to :shift

  validates :status, presence: true, inclusion: { in: STATUSES }
  validate :users_on_same_team
  validate :shift_owned_by_requesting_user, on: :create
  validate :target_is_not_requester

  scope :pending, -> { where(status: "pending") }

  def approve!
    raise ActiveRecord::RecordInvalid, self unless pending?

    transaction do
      shift.update!(user: target_user)
      update!(status: "approved")
    end
  end

  def deny!
    raise ActiveRecord::RecordInvalid, self unless pending?

    update!(status: "denied")
  end

  def pending?
    status == "pending"
  end

  private

  def users_on_same_team
    return if requesting_user.blank? || target_user.blank?
    return if requesting_user.team_id == target_user.team_id

    errors.add(:base, "Both users must be on the same team")
  end

  def shift_owned_by_requesting_user
    return if shift.blank? || requesting_user.blank?
    return if shift.user_id == requesting_user_id

    errors.add(:shift, "must belong to the requesting user")
  end

  def target_is_not_requester
    return if requesting_user_id.blank? || target_user_id.blank?
    return if requesting_user_id != target_user_id

    errors.add(:target_user, "cannot be the same as the requesting user")
  end
end
