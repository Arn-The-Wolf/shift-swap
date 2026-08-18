class Team < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :shifts, dependent: :destroy

  validates :name, presence: true
end
