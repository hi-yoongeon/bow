require 'bow_auth'

# -*- coding: utf-8 -*-
class UserController < ApplicationController
  protect_from_forgery :except => :signup_ok

  public
  def signup
    @ss_id, @screen_name = get_user_id_from_oauth_client_info
  end

  def signup_ok
    redirect_url = session[:redirect_url]
    user_id = facebook_signup params if session[:oauth_type] == "facebook"
    user_id = twitter_signup params if session[:oauth_type] == "twitter"

    session[:user_id] = user_id
    clean_session

    redirect_to redirect_url
  end

  def logout
    reset_session
    redirect_to '/'
  end


  private

  def get_user_id_from_oauth_client_info
    if session[:oauth_type] == "facebook"

      p session[:token]

      oAuth = Bow::Auth::Facebook.new session[:token]
      info = oAuth.client.me.info

      p info
      [info["id"], info["username"]]
    else
      oAuth = Bow::Auth::Twitter.new session[:token], session[:secret]
      info = oAuth.client.info

      p info
      [info["id"], info["screen_name"]]
    end
  end

  def twitter_signup params
    ss_id, screen_name = get_user_id_from_oauth_client_info
    user = nil
    User.transaction do
      user = User.new
      user.nickname = params[:nickname]
      user.email = params[:email]
      user.save

      twitter_user_info = TwitterUserInfo.new
      twitter_user_info.token = session[:token]
      twitter_user_info.secret = session[:secret]
      twitter_user_info.twitter_id = ss_id
      twitter_user_info.screen_name = screen_name
      twitter_user_info.user_id = user.id
      twitter_user_info.save
    end
    user.id
  end

  def facebook_signup params
    ss_id, screen_name = get_user_id_from_oauth_client_info
    user = nil
    User.transaction do
      user = User.new
      user.nickname = params[:nickname]
      user.email = params[:email]
      user.save

      facebook_user_info = FacebookUserInfo.new
      facebook_user_info.token = session[:token]
      facebook_user_info.facebook_id = ss_id
      facebook_user_info.screen_name = screen_name
      facebook_user_info.user_id = user.id
      facebook_user_info.save
    end
    user.id
  end

  def clean_session
    session[:redirect_url] = nil
    session[:token] = nil
    session[:secret] = nil
    session[:oauth_type] = nil
    session[:oauth_info] = nil
    session[:oauth] = nil
  end

end

