require 'bow_auth'

class AuthController < ApplicationController

  def signin
    @redirect_url = params[:redirect_url]
  end

  def twitter
    auth_twitter = session[:oauth] = Bow::Auth::Twitter.new
    #auth_twitter.redirect_url = params[:redirect_url]
    session[:redirect_url] = params[:redirect_url]
    redirect_to auth_twitter.authorize_url
  end

  def facebook
    auth_facebook = session[:oauth] = Bow::Auth::Facebook.new
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
    auth_twitter = session[:oauth]
    access_token = auth_twitter.access_token params[:verifier]
    session[:token], session[:secret] = access_token.token, access_token.secret
    redirect_url = session[:redirect_url]

    twitter_user_info = TwitterUserInfo.find_by_access_token(access_token)

    session[:oauth] = nil
    if twitter_user_info.empty?
      session[:oauth_type] = "twitter"
      redirect_to "/signup"
    else
      factory_user_session twitter_user_info[0].user_id
      session[:redirect_url] = nil
      redirect_to redirect_url
    end
  end

  def facebook_callback
    access_token = session[:oauth].access_token params[:code]
    session[:token] = access_token.token
    facebook_user_info = FacebookUserInfo.find_by_token session[:token]
    session[:oauth] = nil

    p "token : #{session[:token]}"

    if facebook_user_info.empty?
      session[:oauth_type] = "facebook"
      #facebook_info = auth_facebook.client.me.info
      #session[:user_id] = FacebookUserInfo.add_facebook_info :token => token, :facebook_info => facebook_info
      #session[:auth_facebook] = nil
      redirect_to "/signup"
    else
      factory_user_session facebook_user_info[0].user_id
      redirect_url = session[:redirect_url];session[:redirect_url] = nil
      redirect_to redirect_url
    end

  end




end
