# -*- coding: utf-8 -*-
require 'bow_room'

class KennelController < ApplicationController

#  before_filter :authorize, :except => [:bark]
  before_filter :authorize

  def enter

  end

  def bark
    p session
    @kennel_id = params[:room_id]
    p session["user"][:nickname]
    @nickname = session["user"][:nickname]
    @viewport = true
    @profile_image = session["user"][:profile_image]
    # @kennel_id = 1
    # @nickname = 'jeong'

    # for 규용
    k = Bow::Room::KennelManager.instance.kennel params[:room_id]
    k.enter session[:user]

    @title = k.title

    if params[:permit] != "creator"
      sns_send "all", "#{k.title} 토론방에 참여했습니다", k
    end
  end

  def create
    @twitter = @current_user.twitter_user_info
    @facebook = @current_user.facebook_user_info
  end

  def create_ok
    params[:user] = session[:user]
    kennel = Bow::Room::KennelManager.instance.create_kennel params

    params[:sns_send].each do |sns|
      sns_send sns, params[:message], kennel unless sns.empty?
    end

    redirect_to "/bark/#{kennel.id}?permit=creator"
  end

  private
#  def message sns, message, kennel
#    if sns == "twitter"
#      message = message[0..90]
#    end
#    message + " http://seoho.me:3000/bark/#{kennel.id}"
#  end

end
