module SessionsHelper

  def sign_in(user)

    if params[:remember_me] 
      cookies.signed[:remember_token] = {value: [user.id, user.salt],
                         expires: 7.days.from_now }
    else
      cookies.signed[:remember_token] = [user.id, user.salt]
    end
    self.current_user = user
  end

  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  def signed_in?
    !current_user.nil?
  end

  def is_locked?
    if current_user.locked?
      cookies.delete(:remember_token)
      self.current_user = nil
      redirect_to root, error: "Your Account is Locked"
    end
  end

  def is_admin?
    current_user.admin? unless current_user.nil?
  end

  def can_edit_events?
    current_user.edit_events? unless current_user.nil?
  end

  def can_add_dogs?
    current_user.add_dogs? unless current_user.nil?
  end

  def can_edit_dogs?
    current_user.edit_dogs? unless current_user.nil?
  end

  def can_edit_all_adopters?
    current_user.edit_all_adopters unless current_user.nil?
  end

  def can_edit_my_adopters?
    current_user.edit_my_adopters unless current_user.nil?
  end
    
  def can_complete_adopters?
    current_user.complete_adopters unless current_user.nil?
  end

  def can_ban_adopters?
    current_user.ban_adopters unless current_user.nil?
  end

  def can_dl_resources?
    current_user.dl_resources unless current_user.nil?
  end

  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  def current_user?(user)
    user == current_user
  end

  def authenticate
    deny_access unless signed_in?
  end

  def deny_access
    store_location
    redirect_to signin_path, notice: "Please sign in to access this page"
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end

  private

    def user_from_remember_token
      User.authenticate_with_salt(*remember_token)
    end

    def remember_token
      cookies.signed[:remember_token] || [nil, nil]
    end

    def store_location
      session[:return_to] = request.fullpath
    end

    def clear_return_to
      session[:return_to] = nil
    end

end
