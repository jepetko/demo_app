class UsersController < ApplicationController

  before_filter :authenticate, :only => [:edit, :update, :index]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:destroy]

  def new
    if current_user.nil?
      @user = User.new
      @title = "Sign up"
    else
      redirect_to current_user
    end
  end

  def show
    @user = User.find(params[:id])
    @title = @user.name
    @microposts = @user.microposts.paginate( :page => params[:page])
  end

  def create
    if current_user.nil?
      @user = User.new( params[:user])
      if @user.save
        sign_in @user ################ to be automatically signed in (mixed from SessionHelper into ApplicationController)
        flash[:success] = "Welcome to this application"
        redirect_to @user
      else
        @title = "Sign up"
        render 'new'
      end
    else
      redirect_to current_user
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
    @users = User.paginate( :page => params[:page])
    @title = "All users"
  end

  def destroy
    if current_user.admin?
      if( current_user.id.to_s != params[:id] )
        User.find(params[:id]).destroy
        flash[:success] = "User destroyed."
        redirect_to users_path
      else
        redirect_to signin_path
      end
    else
      redirect_to signin_path
    end

  end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      if !current_user.nil?
        redirect_to(signin_path) unless current_user.admin?    #in book root_path
      else
        redirect_to(signin_path)
      end
    end
end