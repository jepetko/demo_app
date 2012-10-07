class UsersController < ApplicationController
  def new
    @user = User.new
    @title = "Sign up"
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def create
    @user = User.new( params[:user])
    if @user.save
      sign_in @user ################ to be automatically signed in (mixed from SessionHelper into ApplicationController)
      flash[:success] = "Welcome to this application"
      redirect_to @user
    else
      @title = "Sign up"
      render 'new'
    end
  end
end