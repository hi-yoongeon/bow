require 'bow_room'

class KennelController < ApplicationController

  before_filter :authorize, :except => [:bark]

  def bark
    # @kennel_id = params[:room_id]
    # @nickname = @current_user.nickname
    @kennel_id = 1
    @nickname = 'jeong'
  end

  def create
    @twitter = @current_user.twitter_user_info
    @facebook = @current_user.facebook_user_info
  end

  def create_ok
    params[:user] = session[:user]
    kennel = Bow::Room::KennelManager.instance.create_kennel params

    params[:sns_send].each do |sns|
      sns_send sns, params[:message]
    end

    redirect_to "/bark/#{kennel.id}"
  end

end
