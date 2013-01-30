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
    #facebook = current_user.oauth_facebook = Bow::Auth::Facebook.new
    #redirect_to facebook.authorize_url
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
      session[:user_id] = TwitterUserInfo.add_twitter_info :access_token => access_token, :client => auth_twitter.client
      p twitter_user_info = auth_twitter.client.info
      session[:auth_twitter] = nil
      redirect_to "/signup?redirect_url=#{params[:redirect_url]}&nickname=#{twitter_user_info['screen_name']}"
    else
      #p twitter_user_info
      session[:user_id] = twitter_user_info[0].user_id
      session[:auth_twitter] = nil
      redirect_to params[:redirect_url]
    end


  end

  def facebook_callback
    
  end




end
