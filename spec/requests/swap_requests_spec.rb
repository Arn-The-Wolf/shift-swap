require "rails_helper"

RSpec.describe "Swap request flows", type: :request do
  let(:team) { Team.create!(name: "Harbor Cafe") }
  let!(:manager) do
    User.create!(
      name: "Maya Chen",
      email: "maya@harbor.test",
      password: "password",
      password_confirmation: "password",
      team: team,
      manager: true
    )
  end
  let!(:requester) do
    User.create!(
      name: "Jordan Lee",
      email: "jordan@harbor.test",
      password: "password",
      password_confirmation: "password",
      team: team,
      manager: false
    )
  end
  let!(:target) do
    User.create!(
      name: "Sam Ortiz",
      email: "sam@harbor.test",
      password: "password",
      password_confirmation: "password",
      team: team,
      manager: false
    )
  end
  let!(:shift) do
    Shift.create!(
      title: "Morning open",
      starts_at: 1.day.from_now,
      ends_at: 1.day.from_now + 4.hours,
      user: requester,
      team: team
    )
  end

  describe "creating a swap request" do
    it "lets a signed-in user request a swap with a teammate" do
      sign_in_as(requester)

      expect {
        post swap_requests_path, params: {
          swap_request: {
            shift_id: shift.id,
            target_user_id: target.id
          }
        }
      }.to change(SwapRequest, :count).by(1)

      expect(response).to redirect_to(dashboard_path)
      request = SwapRequest.last
      expect(request.requesting_user).to eq(requester)
      expect(request.target_user).to eq(target)
      expect(request.status).to eq("pending")
    end
  end

  describe "manager approve/deny" do
    let!(:swap_request) do
      SwapRequest.create!(
        requesting_user: requester,
        target_user: target,
        shift: shift,
        status: "pending"
      )
    end

    it "approves a pending request and reassigns the shift" do
      sign_in_as(manager)

      patch approve_manager_swap_request_path(swap_request)

      expect(response).to redirect_to(manager_swap_requests_path)
      expect(swap_request.reload.status).to eq("approved")
      expect(shift.reload.user).to eq(target)
    end

    it "denies a pending request without reassigning the shift" do
      sign_in_as(manager)

      patch deny_manager_swap_request_path(swap_request)

      expect(response).to redirect_to(manager_swap_requests_path)
      expect(swap_request.reload.status).to eq("denied")
      expect(shift.reload.user).to eq(requester)
    end

    it "supports turbo stream approve responses" do
      sign_in_as(manager)

      patch approve_manager_swap_request_path(swap_request),
            headers: { "Accept" => "text/vnd.turbo-stream.html" }

      expect(response.media_type).to eq(Mime[:turbo_stream])
      expect(swap_request.reload.status).to eq("approved")
    end
  end
end
