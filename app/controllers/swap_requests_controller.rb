class SwapRequestsController < ApplicationController
  before_action :require_login

  def new
    @swap_request = SwapRequest.new
    @shifts = current_user.upcoming_shifts
    @teammates = User.teammates_of(current_user).order(:name)
  end

  def create
    @swap_request = current_user.outgoing_swap_requests.build(swap_request_params)
    @swap_request.status = "pending"
    @shifts = current_user.upcoming_shifts
    @teammates = User.teammates_of(current_user).order(:name)

    if @swap_request.save
      redirect_to dashboard_path, notice: "Swap request sent."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def swap_request_params
    params.require(:swap_request).permit(:shift_id, :target_user_id)
  end
end
