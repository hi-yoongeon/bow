# -*- coding: utf-8 -*-


require 'bow_auth'


class UserController < ApplicationController
  protect_from_forgery :except => :signup_ok

  public
  def signup
    @ss_id, @screen_name = get_user_id_from_oauth_client_info
    if session[:oauth_type] == "twitter"
      @profile_image = "https://api.twitter.com/1/users/profile_image?screen_name=#{@screen_name}&size=bigger"
    else
      @profile_image = "http://graph.facebook.com/#{@ss_id}/picture?type=square"
    end

  end

  def signup_ok
    redirect_url = session[:redirect_url]
    user_id = facebook_signup params if session[:oauth_type] == "facebook"
    user_id = twitter_signup params if session[:oauth_type] == "twitter"
    clean_session
    factory_user_session user_id
    redirect_to redirect_url
  end

  def logout
    clean_session
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

end

