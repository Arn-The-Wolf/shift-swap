require "rails_helper"

RSpec.describe SwapRequest, type: :model do
  let(:team) { Team.create!(name: "Harbor Cafe") }
  let(:requester) do
    User.create!(
      name: "Jordan Lee",
      email: "jordan@harbor.test",
      password: "password",
      password_confirmation: "password",
      team: team
    )
  end
  let(:target) do
    User.create!(
      name: "Sam Ortiz",
      email: "sam@harbor.test",
      password: "password",
      password_confirmation: "password",
      team: team
    )
  end
  let(:shift) do
    Shift.create!(
      title: "Morning open",
      starts_at: 1.day.from_now,
      ends_at: 1.day.from_now + 4.hours,
      user: requester,
      team: team
    )
  end

  def build_request(**attrs)
    SwapRequest.new(
      {
        requesting_user: requester,
        target_user: target,
        shift: shift,
        status: "pending"
      }.merge(attrs)
    )
  end

  it "is valid with required associations" do
    expect(build_request).to be_valid
  end

  it "only allows known statuses" do
    request = build_request(status: "maybe")
    expect(request).not_to be_valid
    expect(request.errors[:status]).to be_present
  end

  it "requires both users on the same team" do
    other_team = Team.create!(name: "Other")
    outsider = User.create!(
      name: "Outsider",
      email: "out@other.test",
      password: "password",
      password_confirmation: "password",
      team: other_team
    )
    request = build_request(target_user: outsider)
    expect(request).not_to be_valid
    expect(request.errors[:base]).to include("Both users must be on the same team")
  end

  it "approves by transferring the shift" do
    request = build_request
    request.save!
    request.approve!
    expect(request.reload.status).to eq("approved")
    expect(shift.reload.user).to eq(target)
  end

  it "denies without transferring the shift" do
    request = build_request
    request.save!
    request.deny!
    expect(request.reload.status).to eq("denied")
    expect(shift.reload.user).to eq(requester)
  end
end
