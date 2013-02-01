require 'bow_room'

class MainController < ApplicationController

  def index

    @room_list = Bow::Room::KennelManager.instance.list

    p @room_list


    if session[:user].nil?
      @profile_image =  "/images/4.png"
    else
      @profile_image =  profile_image
    end






    # @twitter_info = current_user.twitter_user_info

    # p @twitter_info
  end

end
