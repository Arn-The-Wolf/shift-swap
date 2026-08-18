require "rails_helper"

RSpec.describe User, type: :model do
  let(:team) { Team.create!(name: "Harbor Cafe") }

  def build_user(**attrs)
    User.new(
      {
        name: "Jordan Lee",
        email: "jordan@harbor.test",
        password: "password",
        password_confirmation: "password",
        team: team
      }.merge(attrs)
    )
  end

  it "is valid with required attributes" do
    expect(build_user).to be_valid
  end

  it "requires name, email, and password" do
    user = User.new(team: team)
    expect(user).not_to be_valid
    expect(user.errors[:name]).to be_present
    expect(user.errors[:email]).to be_present
    expect(user.errors[:password]).to be_present
  end

  it "enforces unique emails" do
    build_user.save!
    duplicate = build_user(email: "JORDAN@harbor.test")
    expect(duplicate).not_to be_valid
    expect(duplicate.errors[:email]).to include("has already been taken")
  end

  it "belongs to a team and has many shifts" do
    expect(User.reflect_on_association(:team).macro).to eq(:belongs_to)
    expect(User.reflect_on_association(:shifts).macro).to eq(:has_many)
  end

  it "authenticates with has_secure_password" do
    user = build_user
    user.save!
    expect(user.authenticate("password")).to eq(user)
    expect(user.authenticate("wrong")).to eq(false)
  end
end
