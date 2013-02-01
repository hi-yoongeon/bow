require 'bow_room'
require 'bow_auth'

class ApplicationController < ActionController::Base
  protect_from_forgery :secret => "ygmaster"
  before_filter :authorized_user


  def sns_message
    k = Bow::Room::KennelManager.instance.kennel, params[:kennel_id] unless params[:kennel_id].nil?
    sns_send params[:type], params[:msg], k
#    render :text => "200"
  end

  protected
  def factory_user_session user_id
    user = User.find user_id
    session[:user] = {
      :id => user.id,
      :email => user.email,
      :nickname => user.nickname,
    }
  end

  def authorized_user
    @current_user = User.find_by_id session[:user][:id] unless session[:user].nil?
    unless session[:user].nil?
      session[:user][:profile_image] = profile_image if session[:user][:profile_image].nil?
    end
  end

  def authorize
    redirect_to "/signin?redirect_url=#{request.fullpath}" if session[:user].nil?
  end


  def sns_send type, msg, kennel = nil
    if type == "all"
      twitter_oauth.send msg, kennel unless twitter_oauth.nil?
      facebook_oauth.send msg, kennel unless facebook_oauth.nil?
    end

    twitter_oauth.send msg, kennel if type == "twitter"
    facebook_oauth.send msg, kennel if type == "facebook"
  end

  def profile_image
    twitter_user_info = @current_user.twitter_user_info
    facebook_user_info = @current_user.facebook_user_info
    unless twitter_user_info.nil?
      return "https://api.twitter.com/1/users/profile_image?screen_name=#{twitter_user_info.screen_name}&size=bigger"
    end
    unless facebook_user_info.nil?
      return "http://graph.facebook.com/#{facebook_user_info.facebook_id}/picture?type=square"
    end
  end

  def twitter_oauth
    info = @current_user.twitter_user_info
    Bow::Auth::Twitter.new info.token, info.secret unless info.nil?
  end

  def facebook_oauth
    info = @current_user.facebook_user_info
    Bow::Auth::Facebook.new info.token unless info.nil?
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
