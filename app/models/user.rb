class User < ApplicationRecord
  has_secure_password

  belongs_to :team
  has_many :shifts, dependent: :destroy
  has_many :outgoing_swap_requests, class_name: "SwapRequest", foreign_key: :requesting_user_id, dependent: :destroy, inverse_of: :requesting_user
  has_many :incoming_swap_requests, class_name: "SwapRequest", foreign_key: :target_user_id, dependent: :destroy, inverse_of: :target_user

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || password.present? }

  before_validation :normalize_email

  scope :managers, -> { where(manager: true) }
  scope :teammates_of, ->(user) { where(team_id: user.team_id).where.not(id: user.id) }

  def upcoming_shifts
    shifts.upcoming.order(:starts_at)
  end

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end
end
