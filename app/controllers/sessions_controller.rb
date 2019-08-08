class SessionsController < ApplicationController

 before_action :require_logged_out, only: [:new, :create]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(
      params[:user][:email],
      params[:user][:password]
    )

    if @user.save 
      login(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors].errors.full_messages
      render :new
    end
  end

  def destroy
    logout
    redirect_to new_session_url
  end

end
