# -*- coding: utf-8 -*-

require 'twitter'

class LoginController < ApplicationController


  def index
    
  end

  def facebook # 고창규님 구현

  end

  def twitter # ygmaster 구현
    if params[:id] == "callback"
      access_token params[:oauth_verifier]
    else
      redirect_to authorize_url
    end
  end 

  

  private
  def twt
    session[:twitter] = Bow::Twitter.new if session[:twitter].nil?
    session[:twitter]
  end
  def authorize_url
    twt.get_authorize_url
  end
  def access_token(oauth_verifier)
    access_token = twt.get_access_token oauth_verifier
    @access_token = access_token.token
    @access_secret = access_token.secret
  end
end
