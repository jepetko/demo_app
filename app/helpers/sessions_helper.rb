module SessionsHelper

  def sign_in(user)
    puts "sign_in"
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    current_user = user
  end

  def current_user=(user)
    puts "current_user SETTER"
    @current_user = user
  end

  def current_user
    puts "current_user GETTER"
    @current_user ||= user_from_remember_token
  end

  def current_user?(user)
    user == current_user #call method current_user for that
  end

  private

  def user_from_remember_token
    puts "user_from_remember_token"
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    puts "remember_token"
    puts cookies.signed[:remember_token]
    cookies.signed[:remember_token] || [nil,nil]
  end

  def signed_in?
    puts "signed_in?"
    puts "current_user: " + current_user.to_s
    puts cookies.signed[:remember_token]
    puts ".....: " + @current_user.inspect
    !current_user.nil?
  end

  #######################

  def sign_out
    cookies.delete(:remember_token)
    current_user = nil
  end

  def signed_out?
     current_user.nil
  end

  #########################

  def deny_access
    #flash[:notice] = "...."
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  def correct_user(user)
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def clear_return_to
    session[:return_to] = nil
  end

end
