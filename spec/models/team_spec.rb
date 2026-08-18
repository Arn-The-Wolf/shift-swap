require "rails_helper"

RSpec.describe Team, type: :model do
  it "is valid with a name" do
    expect(Team.new(name: "Harbor Cafe")).to be_valid
  end

  it "requires a name" do
    team = Team.new(name: nil)
    expect(team).not_to be_valid
    expect(team.errors[:name]).to include("can't be blank")
  end

  it "has many users and shifts" do
    expect(Team.reflect_on_association(:users).macro).to eq(:has_many)
    expect(Team.reflect_on_association(:shifts).macro).to eq(:has_many)
  end
end
