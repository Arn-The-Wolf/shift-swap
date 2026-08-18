class Manager::SwapRequestsController < ApplicationController
  before_action :require_login
  before_action :require_manager
  before_action :set_swap_request, only: %i[approve deny]

  def index
    @pending_requests = SwapRequest.pending
                                   .joins(:requesting_user)
                                   .where(users: { team_id: current_user.team_id })
                                   .includes(:requesting_user, :target_user, :shift)
                                   .order(created_at: :desc)
  end

  def approve
    @swap_request.approve!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to manager_swap_requests_path, notice: "Swap approved." }
    end
  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(@swap_request, partial: "manager/swap_requests/swap_request", locals: { swap_request: @swap_request }) }
      format.html { redirect_to manager_swap_requests_path, alert: "Could not approve that request." }
    end
  end

  def deny
    @swap_request.deny!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to manager_swap_requests_path, notice: "Swap denied." }
    end
  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace(@swap_request, partial: "manager/swap_requests/swap_request", locals: { swap_request: @swap_request }) }
      format.html { redirect_to manager_swap_requests_path, alert: "Could not deny that request." }
    end
  end

  private

  def set_swap_request
    @swap_request = SwapRequest.joins(:requesting_user)
                               .where(users: { team_id: current_user.team_id })
                               .find(params[:id])
  end
end
