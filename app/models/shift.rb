class Shift < ApplicationRecord
  belongs_to :user
  belongs_to :team
  has_many :swap_requests, dependent: :destroy

  validates :title, presence: true
  validates :starts_at, :ends_at, presence: true
  validate :ends_after_starts
  validate :user_belongs_to_team

  scope :upcoming, -> { where("starts_at >= ?", Time.current).order(:starts_at) }

  def duration_label
    start_label = starts_at.strftime("%a %b %d, %Y %I:%M %p").gsub(" 0", " ")
    end_label = ends_at.strftime("%I:%M %p").sub(/^0/, "")
    "#{start_label} – #{end_label}"
  end

  def option_label
    "#{title} · #{duration_label}"
  end

  private

  def ends_after_starts
    return if starts_at.blank? || ends_at.blank?
    return if ends_at > starts_at

    errors.add(:ends_at, "must be after start time")
  end

  def user_belongs_to_team
    return if user.blank? || team.blank?
    return if user.team_id == team_id

    errors.add(:user, "must belong to the shift's team")
  end
end
