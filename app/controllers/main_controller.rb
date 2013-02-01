require 'bow_room'

class MainController < ApplicationController

  def index
    
    @room_list = Bow::Room::KennelManager.instance.list

    p @room_list

    # @twitter_info = current_user.twitter_user_info

    # p @twitter_info
  end

end
