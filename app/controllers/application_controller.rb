require 'bow_auth'

class ApplicationController < ActionController::Base
  protect_from_forgery :secret => "ygmaster"
  before_filter :authorized_user

  protected
  def factory_user_session user_id
    user = User.find user_id
    session[:user] = {
      :id => user.id,
      :nickname => user.nickname
    }
  end

  def authorized_user
    @current_user = User.find_by_id session[:user][:id] unless session[:user].nil?
  end

  def authorize
    redirect_to "/signin?redirect_url=#{request.fullpath}" if session[:user].nil?
  end


  def sns_send type, msg
    twitter_oauth.send msg if type == "twitter"
    facebook_oauth.send msg if type == "facebook"
  end

  def twitter_oauth
    info = @current_user.twitter_user_info
    Bow::Auth::Twitter.new info.token, info.secret
  end

  def facebook_oauth
    info = @current_user.facebook_user_info
    Bow::Auth::Facebook.new info.token
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
