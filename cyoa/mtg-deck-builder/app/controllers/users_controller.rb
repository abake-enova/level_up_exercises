class UsersController < ApplicationController
  before_action :require_logged_in, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    @decks = @user.decks.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      success_message = "Awesome! Your profile has been updated."
      redirect_to @user, flash: { success: success_message }
    else
      render 'edit'
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      success_message = "Woohoo! Welcome to MTG Deck builder!"
      redirect_to @user, flash: { success: success_message }
    else
      render 'new'
    end
  end

  def destroy
    current_user.destroy
    redirect_to "/", flash: { success: "Your account has been destroyed." }
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :username,
      :password,
      :password_confirmation)
  end

  def require_logged_in
    unless logged_in?
      redirect_to login_url, flash: { error: "Oops! You need to log in." }
    end
  end
end
