class UsersController < ApplicationController
  def new
    redirect_to dashboard_path and return if logged_in?

    @user = User.new
    @teams = Team.order(:name)
  end

  def create
    @user = User.new(user_params)
    @teams = Team.order(:name)

    if @user.save
      reset_session
      session[:user_id] = @user.id
      redirect_to dashboard_path, notice: "Account created. You're in."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :team_id)
  end
end
