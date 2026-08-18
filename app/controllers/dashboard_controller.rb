class DashboardController < ApplicationController
  before_action :require_login

  def show
    @upcoming_shifts = current_user.upcoming_shifts.includes(:team)
    @pending_outgoing = current_user.outgoing_swap_requests.pending.includes(:target_user, :shift)
    @pending_incoming = current_user.incoming_swap_requests.pending.includes(:requesting_user, :shift)
  end
end
