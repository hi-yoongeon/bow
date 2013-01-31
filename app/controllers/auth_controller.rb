require 'bow_auth'

class AuthController < ApplicationController

  layout false

  def signin
    @redirect_url = params[:redirect_url]
  end

  def twitter
    auth_twitter = session[:auth_twitter] = Bow::Auth::Twitter.new
    auth_twitter.redirect_url = params[:redirect_url]
    redirect_to auth_twitter.authorize_url
  end

  def facebook
    auth_facebook = session[:auth_facebook] = Bow::Auth::Facebook.new
    session[:redirect_url] = params[:redirect_url]
    redirect_to auth_facebook.authorize_url
  end

  def callback
    case params[:type]
    when "twitter" then twitter_callback
    when "facebook" then facebook_callback
    end
  end

  def twitter_callback

    auth_twitter = session[:auth_twitter]
    access_token = auth_twitter.access_token params[:verifier]
    twitter_user_info = TwitterUserInfo.find_by_access_token(access_token)
    need_signup = false

    if twitter_user_info.empty?
      #p "insert twitter_user_info & signup"
      twitter_info = auth_twitter.client.info
      session[:user_id] = TwitterUserInfo.add_twitter_info :access_token => access_token, :twitter_info => twitter_info
      session[:auth_twitter] = nil
      redirect_to "/signup?redirect_url=#{params[:redirect_url]}&nickname=#{twitter_info['screen_name']}"
    else
      #p twitter_user_info
      session[:user_id] = twitter_user_info[0].user_id
      session[:auth_twitter] = nil
      redirect_to params[:redirect_url]
    end


  end

  def facebook_callback
    code = params[:code]
    redirect_url = session[:redirect_url]
    auth_facebook = session[:auth_facebook]
    access_token = auth_facebook.access_token code
    session[:redirect_url] = nil

    token = access_token.token

    facebook_user_info = FacebookUserInfo.find_by_token token

    if facebook_user_info.empty?
      facebook_info = auth_facebook.client.me.info
      session[:user_id] = FacebookUserInfo.add_facebook_info :token => token, :facebook_info => facebook_info
      session[:auth_facebook] = nil
      redirect_to "/signup?redirect_url=#{redirect_url}&nickname=#{facebook_info['username']}"
    else
      session[:user_id] = facebook_user_info[0].user_id
      session[:auth_facebook] = nil
      redirect_to redirect_url
    end

  end




end
