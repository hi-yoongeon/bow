class ApplicationController < ActionController::Base
  protect_from_forgery :secret => "ygmaster"


  protected
  def current_user
    user = User.find session[:user_id] unless session[:user_id].nil?
    user
  end  

  protected
  def current_user_id
    session[:user_id]
  end


  def authorize
    p current_user_id
    redirect_to "/signin?redirect_url=#{request.fullpath}" if current_user_id.nil?
  end

end
