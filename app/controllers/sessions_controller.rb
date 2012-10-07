class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    ses = params[:session]
    user = User.authenticate( ses[:email], ses[:password])

    if user.nil?
      flash.now[:error] = "Sign-in data invalid"
      @title = "Sign in"
      render :new
    else
      sign_in user
      redirect_to user
    end
  end

  def destroy
    sign_out
    redirect_to root_path
  end
end
