class MicropostsController < ApplicationController

  before_filter :authenticate, :only => [:create, :destroy]

  def create
    @micropost = current_user.microposts.build( params[:micropost] )
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_path
    else
      flash[:error] = "Micropost could not be created."
      @feed_items = []              ################# bug in book; feed_items variable is needed inside _feed.html.erb!!!
      render 'pages/home'
    end
  end

  def destroy

  end

end