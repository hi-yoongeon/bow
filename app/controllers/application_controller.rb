class ApplicationController < ActionController::Base
  protect_from_forgery :secret => "ygmaster"
  before_filter :factory_user

  protected
  def factory_user
    @current_user = User.find_by_id session[:user_id] unless session[:user_id].nil?
  end

  def current_user_id
    session[:user_id]
  end

  def authorize
    redirect_to "/signin?redirect_url=#{request.fullpath}" if current_user_id.nil?
  end

end
