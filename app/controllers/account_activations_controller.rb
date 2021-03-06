class AccountActivationsController < ApplicationController
  def edit
    @user = User.find_by(email: params[:email])
    if @user && !@user.activated? && @user.authenticated?(:activation,
                                                          params[:id])
      activate_account
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to home_path
    end
  end

  private

  def activate_account
    @user.activate
    log_in @user
    flash[:success] = 'Account activated!'
    redirect_to @user
  end
end
