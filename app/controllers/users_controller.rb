class UsersController < ApplicationController

  before_filter :authenticate, :only => [:edit, :update, :index]
  before_filter :correct_user, :only => [:edit, :update]

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

  def edit
    @user = User.find( params[:id])
    @title = "Edit user"
  end

  def update
    @user = User.find( params[:id])
    if @user.update_attributes( params[:user])
      flash[:success] = "Your data have been updated"
      redirect_to @user
    else
      flash[:error] = "Your data are invalid"
      @title = "Edit user"
      render 'edit'
    end
  end

  def index
    @users = User.all
    @title = "All users"
  end

  private

    def authenticate
      deny_access unless signed_in?
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
end