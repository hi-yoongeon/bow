# -*- coding: utf-8 -*-
class UserController < ApplicationController
  protect_from_forgery :except => :signup
  def signup
    if request.method == "POST"
      user = User.find session[:user_id]
      user.nickname = params[:nickname]
      user.email = params[:email]
      user.save

      redirect_to params[:redirect_url]
    end
    @redirect_url = params[:redirect_url]
    @nickname = params[:nickname]
  end
  
  def logout
    reset_session
    redirect_to '/'
  end

end
