require "rails_helper"

RSpec.describe Shift, type: :model do
  let(:team) { Team.create!(name: "Harbor Cafe") }
  let(:user) do
    User.create!(
      name: "Jordan Lee",
      email: "jordan@harbor.test",
      password: "password",
      password_confirmation: "password",
      team: team
    )
  end

  def build_shift(**attrs)
    Shift.new(
      {
        title: "Morning open",
        starts_at: 1.day.from_now,
        ends_at: 1.day.from_now + 4.hours,
        user: user,
        team: team
      }.merge(attrs)
    )
  end

  it "is valid with required attributes" do
    expect(build_shift).to be_valid
  end

  it "requires title and time range" do
    shift = Shift.new(user: user, team: team)
    expect(shift).not_to be_valid
    expect(shift.errors[:title]).to be_present
    expect(shift.errors[:starts_at]).to be_present
    expect(shift.errors[:ends_at]).to be_present
  end

  it "requires ends_at after starts_at" do
    shift = build_shift(ends_at: 1.day.from_now - 1.hour)
    expect(shift).not_to be_valid
    expect(shift.errors[:ends_at]).to include("must be after start time")
  end

  it "belongs to user and team" do
    expect(Shift.reflect_on_association(:user).macro).to eq(:belongs_to)
    expect(Shift.reflect_on_association(:team).macro).to eq(:belongs_to)
  end
end
